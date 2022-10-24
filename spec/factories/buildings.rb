# frozen_string_literal: true

FactoryBot.define do
  factory :building, class: 'Building' do
    name { 'My building' }
    initialize_with { Building.find_or_create_by(name: name) }
  end
end
