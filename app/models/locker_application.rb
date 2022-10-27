# frozen_string_literal: true

class LockerApplication < ApplicationRecord
  belongs_to :user
  has_one :locker_assignment
  belongs_to :building, optional: true

  delegate :uid, :email, :name, :department, :status, to: :user

  def self.awaiting_assignment
    left_joins(:locker_assignment).where('locker_assignments.id is null').order('locker_applications.created_at')
  end

  after_initialize do |_locker_application|
    if user.present?
      self.department_at_application ||= department
      self.status_at_application ||= status
    end
  end

  def building_choices
    placeholder = { label: 'Select Library', value: 'placeholder', disabled: true }
    choices = [placeholder]
    choices.concat(Building.all.map { |building| { label: building.name, value: building.id } })
  end

  def size_choices
    choices = LockerAndStudySpaces.config.fetch(:locker_sizes, [])
    choices = [choices.first] if user.blank? || user.junior?
    prepare_size_choices_for_lux(choices)
  end

  def floor_choices
    choices = LockerAndStudySpaces.config.fetch(:locker_floor_choices, []).keys
    prepare_choices_for_lux(choices)
  end

  def semester_choices
    choices = LockerAndStudySpaces.config.fetch(:semesters, [])
    prepare_semester_choices_for_lux(choices)
  end

  def status_choices
    choices = LockerAndStudySpaces.config.fetch(:statuses, [])
    prepare_choices_for_lux(choices)
  end

  def department_list
    self.class.all.pluck(:department_at_application).uniq.sort
  end

  def department_choices
    prepare_choices_for_lux(department_list)
  end

  def available_lockers_in_area_and_size(building:)
    context = Locker.available_lockers(building: building)
    context = context.where(floor: preferred_general_area) if preferred_general_area.present? && preferred_general_area != 'No preference'
    context = context.where(size: preferred_size) if preferred_size.present?
    context.order(:location)
  end

  def self.search(uid:)
    return all if uid.blank?

    joins(:user).where("users.uid = '#{uid}'")
  end
end
