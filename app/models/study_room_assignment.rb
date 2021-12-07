# frozen_string_literal: true

class StudyRoomAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :study_room

  delegate :uid, :email, :name, to: :user
  delegate :general_area, :location, to: :study_room

  def release
    self.released_date = DateTime.now.to_date
    save!
  end
end
