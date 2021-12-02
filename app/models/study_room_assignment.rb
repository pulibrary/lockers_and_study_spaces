# frozen_string_literal: true

class StudyRoomAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :study_room

  delegate :uid, to: :user

  def release
    self.released_date = DateTime.now.to_date
    save!
  end
end
