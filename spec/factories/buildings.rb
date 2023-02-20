# frozen_string_literal: true

FactoryBot.define do
  factory :building, class: 'Building' do
    name { 'Firestone Library' }
    email { 'access@princeton.edu' }
    initialize_with { Building.find_or_create_by(name:) }
  end
end
