# frozen_string_literal: true

FactoryBot.define do
  factory :study_room_violation do
    study_room { FactoryBot.create(:study_room) }
    user { FactoryBot.create(:user) }
    number_of_books { 5 }
  end
end
