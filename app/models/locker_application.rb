# frozen_string_literal: true

class LockerApplication < ApplicationRecord
  belongs_to :user
  has_one :locker_assignment

  def self.awaiting_assignment
    left_joins(:locker_assignment).where('locker_assignments.id is null').order('locker_applications.created_at')
  end

  def initialize(*args)
    super
    return unless user.present?

    self.department_at_application ||= applicant.department
    self.status_at_application ||= applicant.status
  end

  def applicant
    return nil unless user.present?

    @applicant ||= Applicant.new(user)
  end

  def size_choices
    choices = LockerAndStudySpaces.config.fetch(:locker_sizes, [])
    choices = [choices.first] if user.blank? || applicant.junior?
    prepare_choices_for_lux(choices)
  end

  def general_area_choices
    choices = LockerAndStudySpaces.config.fetch(:general_locations, [])
    prepare_choices_for_lux(choices)
  end

  def semester_choices
    choices = LockerAndStudySpaces.config.fetch(:semesters, [])
    prepare_choices_for_lux(choices)
  end

  def status_choices
    choices = LockerAndStudySpaces.config.fetch(:statuses, [])
    prepare_choices_for_lux(choices)
  end

  def available_lockers_in_area
    Locker.available_lockers.where(general_area: preferred_general_area).order(:location)
  end
end
