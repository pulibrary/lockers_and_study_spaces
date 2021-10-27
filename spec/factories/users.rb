# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| "uid#{n}" }
    provider { 'cas' }
    trait :admin do
      admin { true }
    end
  end
end
