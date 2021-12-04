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

  private

  def clear_assignments
    study_room_assignments = StudyRoomAssignment.where(study_room_id: id).where(released_date: nil)
    study_room_assignments.each(&:release)
  end
end
