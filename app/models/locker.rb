# frozen_string_literal: true

class Locker < ApplicationRecord
  validates :location, presence: true
  validates :general_area, presence: true
  validates :combination, presence: true

  def self.available_lockers
    where.not(id: LockerAssignment.where(released_date: nil).pluck(:locker_id))
  end

  def size_choices
    choices = LockerAndStudySpaces.config.fetch(:locker_sizes, [])
    prepare_choices_for_lux(choices)
  end

  def general_area_choices
    choices = LockerAndStudySpaces.config.fetch(:general_locations, [])
    prepare_choices_for_lux(choices)
  end

  def current_assignment
    @current_assignment ||= LockerAssignment.where(locker_id: id, released_date: nil).first
  end
end
