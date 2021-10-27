# frozen_string_literal: true

class LockerAssignment < ApplicationRecord
  belongs_to :locker
  belongs_to :locker_application

  validates :start_date, presence: true
end
