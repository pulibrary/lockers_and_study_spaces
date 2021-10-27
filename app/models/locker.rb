# frozen_string_literal: true

class Locker < ApplicationRecord
  validates :location, presence: true
  validates :general_area, presence: true
  validates :combination, presence: true
end
