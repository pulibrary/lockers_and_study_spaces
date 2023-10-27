# frozen_string_literal: true

class LockerApplication < ApplicationRecord
  belongs_to :user
  has_one :locker_assignment
  belongs_to :building

  delegate :uid, :email, :name, :department, :status, to: :user

  scope :active, -> { where(complete: true, archived: false) }
  scope :without_current_assignment, lambda {
    where('NOT EXISTS (:locker_assignments)',
          locker_assignments: LockerAssignment.active
                                              .where('locker_assignments.locker_application_id = locker_applications.id'))
  }

  def self.awaiting_assignment
    where(complete: true).where.missing(:locker_assignment).order('locker_applications.created_at')
  end

  def self.mark_applications_complete
    LockerApplication.where(complete: nil).find_each { |application| application.update(complete: true) }
  end

  after_initialize do |_locker_application|
    if user.present?
      self.department_at_application ||= department
      self.status_at_application ||= status
    end
  end

  def accessibility_needs_choices(building)
    choices = LockerAndStudySpaces.config[:accessibility_needs_choices][building&.name] || []
    choices.map { |key, val| { id: key, description: val } }
  end

  def size_choices(building_name)
    choices = LockerAndStudySpaces.config.fetch(:locker_sizes, [])[building_name]
    choices = [choices.first] if user.blank? || user.junior?
    prepare_size_choices_for_lux(choices, building_name)
  end

  def floor_choices(building_name)
    choices = if building_name == 'Firestone Library'
                LockerAndStudySpaces.config.fetch(:firestone_locker_floor_choices, []).keys
              else
                LockerAndStudySpaces.config.fetch(:lewis_locker_floor_choices, []).keys
              end
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
    self.class.pluck(:department_at_application).uniq.sort
  end

  def department_choices
    prepare_choices_for_lux(department_list)
  end

  def available_lockers_in_area_and_size(building:)
    context = Locker.available_lockers(building:)
    context = context.where(floor: preferred_general_area) if preferred_general_area.present? && preferred_general_area != 'No preference'
    context = context.where(size: preferred_size) if preferred_size.present?
    context.order(:location)
  end

  def self.search(uid:, archived:, building_id:)
    if uid.present?
      return joins(:user).where("users.uid = '#{uid}'").where('locker_applications.archived = false').where(complete: true).where(building_id:)
    end
    return where(complete: true).where(archived:).where(building_id:) unless archived

    where(complete: true).where(building_id:)
  end

  def self.migrate_accessible_field
    LockerApplication.where(accessible: true).where.missing(:locker_assignment).find_each do |application|
      needs = application.accessibility_needs
      needs << 'Unspecified accessibility need'
      application.update(accessibility_needs: needs)
    end
  end

  def duplicates
    LockerApplication.includes(:user, :building)
                     .active                      # Disregard incomplete and archived applications
                     .without_current_assignment  # Disregard applications that have already gone through the whole cycle of assignment and release
                     .where(user:)                # Include only applications made by the same user as this one
                     .where.not(id:)              # Don't include this specific application as a duplicate of itself
  end
end
