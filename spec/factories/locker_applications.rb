# frozen_string_literal: true

FactoryBot.define do
  factory :locker_application do
    user { FactoryBot.create(:user) }
    preferred_size { 4 }
    preferred_general_area { 'A floor' }
    accessible { false }
    status_at_application { 'senior' }
    applicant { Applicant.new(user, ldap: {}) }
    sequence(:department_at_application) { |n| "department-#{n}" }
  end
end
