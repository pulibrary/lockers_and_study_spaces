# frozen_string_literal: true

FactoryBot.define do
  factory :study_room do
    sequence(:location) { |n| "location-1#{n}" }
    general_area { 'location-1' }
    notes { 'note' }
  end
end
