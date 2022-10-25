# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation menu', type: :feature, js: true do
  let(:building) { FactoryBot.create :building, name: 'Lewis Library' }
  let(:user) { FactoryBot.create :user, :admin, building: building }

  before do
    sign_in user
  end

  context 'when Lewis Library staff features are turned on' do
    before do
      allow(Flipflop).to receive(:lewis_staff?).and_return(true)
    end

    it 'can see locker management navbar item' do
      visit '/'
      expect(page).to have_content('Locker Management')
    end
  end

  context 'when Lewis Library staff features are turned off' do
    before do
      allow(Flipflop).to receive(:lewis_staff?).and_return(false)
    end

    it 'cannot see locker management navbar item' do
      visit '/'
      expect(page).not_to have_text('Locker Management')
    end

    context 'when user is a Firestone admin' do
      let(:building) { FactoryBot.create :building, name: 'Firestone Library' }

      it 'can see locker management navbar item' do
        visit '/'
        expect(page).to have_text('Locker Management')
      end
    end
  end

  context 'when user is not an admin' do
    let(:user) { FactoryBot.create :user, admin: false }

    it 'cannot see locker management navbar item' do
      visit '/'
      expect(page).not_to have_text('Locker Management')
    end
  end
end
