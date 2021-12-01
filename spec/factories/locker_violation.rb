# frozen_string_literal: true

FactoryBot.define do
  factory :locker_violation do
    locker { FactoryBot.create(:locker) }
    user { FactoryBot.create(:user) }
    number_of_books { 5 }
  end
end
