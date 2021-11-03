# frozen_string_literal: true

class Locker < ApplicationRecord
  validates :location, presence: true
  validates :general_area, presence: true
  validates :combination, presence: true

  def self.available_lockers
    where.not(id: LockerAssignment.where(released_date: nil).pluck(:locker_id))
  end
end
