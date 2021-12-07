# frozen_string_literal: true

class StudyRoom < ApplicationRecord
  validates :location, presence: true
  validates :general_area, presence: true

  def self.general_areas
    LockerAndStudySpaces.config.fetch(:study_room_locations, [])
  end

  def assign_user(uid)
    return clear_assignments if uid.blank?

    user = User.from_uid(uid)
    study_room_assignment = StudyRoomAssignment.find_by(user: user, study_room: self)
    return if study_room_assignment.present? # assignment already exists, no changes needed

    # release any existing assignment
    current_assignment.release if current_assignment.present?
    StudyRoomAssignment.create(user: user, study_room: self)

    #send mail
    
  end

  def current_uid
    return '' if current_assignment.blank?

    current_assignment.uid
  end

  def current_assignment
    @current_assignment ||= StudyRoomAssignment.where(study_room_id: id, released_date: nil).first
  end

  def to_s
    location
  end

  def space_totals
    @space_totals ||= self.class.group(:general_area).count
  end

  def space_assigned_totals
    @space_assigned_totals ||= StudyRoomAssignment.where(released_date: nil).joins(:study_room)
                                                  .group(:general_area).order(:general_area).count
  end

  def space_report
    space_totals.map do |key, total|
      # second total is there to match lockers.  Lockers has the ability to disable one, but study room locations do not
      [key, [total, total, space_assigned_totals[key], total - space_assigned_totals[key]]]
    end.compact.to_h
  end

  private

  def clear_assignments
    study_room_assignments = StudyRoomAssignment.where(study_room_id: id).where(released_date: nil)
    study_room_assignments.each(&:release)
  end
end
