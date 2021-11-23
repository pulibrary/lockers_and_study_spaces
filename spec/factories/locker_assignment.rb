# frozen_string_literal: true

FactoryBot.define do
  factory :locker_assignment do
    locker { FactoryBot.create(:locker) }
    locker_application { FactoryBot.create(:locker_application) }
    start_date { DateTime.now.to_date }
    expiration_date { DateTime.now.to_date.next_year }
  end
end
