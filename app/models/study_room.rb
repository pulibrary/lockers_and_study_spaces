# frozen_string_literal: true

class StudyRoom < ApplicationRecord
  validates :location, presence: true
  validates :general_area, presence: true

  def to_s
    location
  end
end
