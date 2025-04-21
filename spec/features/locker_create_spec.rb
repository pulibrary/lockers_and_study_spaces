# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe 'Locker Create', :js do
  let(:building) { FactoryBot.create(:building, name: 'Firestone Library') }
  let(:user) { FactoryBot.create(:user, :admin, building:) }

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
      expect(page).to have_current_path %r{/lockers/\d+}
    end.to change(Locker, :count).by(1)

    expect(Locker.order('created_at').last.building).to eq(building)
  end

  it 'indicates the required fields' do
    visit '/lockers/new'
    required_fields = ['Location', 'General Area', 'Combination']
    required_fields.each do |field|
      expect(page.find_field(field)[:required]).to eq 'true'
    end
  end

  context 'when Lewis patron feature is on' do
    before do
      allow(Flipflop).to receive_messages(lewis_patrons?: true, lewis_staff?: true)
    end

    it 'shows the Firestone floor options' do
      visit '/lockers/new'
      expect(page).to have_select('locker_floor', options: ['A floor', 'B floor', 'C floor', '2nd floor', '3rd floor'])
    end

    context 'when Lewis admin is logged in' do
      let(:building) { FactoryBot.create(:building, name: 'Lewis Library') }

      it 'shows the Lewis floor options' do
        visit '/lockers/new'
        expect(page).to have_select('locker_floor', options: ['3rd floor', '4th floor'])
      end
    end
  end
end
