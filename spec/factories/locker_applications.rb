# frozen_string_literal: true

FactoryBot.define do
  factory :locker_application do
    user { FactoryBot.create(:user) }
    preferred_size { 4 }
    preferred_general_area { 'location-1' }
    accessible { false }
  end
end
