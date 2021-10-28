# frozen_string_literal: true

FactoryBot.define do
  factory :locker do
    sequence(:location) { |n| "location-1#{n}" }
    size { 4 }
    general_area { 'location-1' }
    accessible { false }
    floor { 1 }
    combination { '11-22-33' }
  end
end
