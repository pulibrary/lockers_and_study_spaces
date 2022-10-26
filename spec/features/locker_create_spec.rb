# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe 'Locker Create', type: :feature, js: true do
  let(:building) { FactoryBot.create(:building, name: 'Firestone Library') }
  let(:user) { FactoryBot.create(:user, :admin, building: building) }

  before do
    sign_in user
    building
  end

  it 'enables me to create a locker at my building' do
    visit '/lockers/new'
    fill_in 'Location', with: SecureRandom.hex
    select 4, from: 'Size'
    fill_in 'Combination', with: SecureRandom.hex
    fill_in 'General Area', with: SecureRandom.hex

    expect do
      click_button 'Submit Locker'
    end.to change(Locker, :count).by(1)

    expect(Locker.order('created_at').last.building).to eq(building)
  end
end
