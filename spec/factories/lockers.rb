# frozen_string_literal: true

FactoryBot.define do
  factory :locker do
    size { 4 }
    sequence(:general_area) { |n| "location-#{n}" }
    sequence(:location) { |n| "#{general_area}-#{n}" }
    accessible { false }
    disabled { false }
    floor { '2nd floor' }
    combination { '11-22-33' }
    building { FactoryBot.create(:building) }
  end
end
