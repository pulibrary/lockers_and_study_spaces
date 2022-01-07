# frozen_string_literal: true

class StudyRoomViolation < ApplicationRecord
  belongs_to :study_room
  belongs_to :user

  delegate :location, to: :study_room
  delegate :email, :name, :number_of_violations, to: :user

  def current_user
    @current_user ||= study_room.current_assignment&.user
    @user = @current_user
    @current_user
  end
end
