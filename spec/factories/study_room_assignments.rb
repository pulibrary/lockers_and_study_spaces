# frozen_string_literal: true

FactoryBot.define do
  factory :study_room_assignment do
    user { FactoryBot.create :user }
    study_room { FactoryBot.create :study_room }
  end
end
