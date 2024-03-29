# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| "uid#{n}" }
    provider { 'cas' }
    applicant { Applicant.new(self, ldap: {}) }
    trait :admin do
      admin { true }
    end
    building { FactoryBot.create(:building) }
  end
end
