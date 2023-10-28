# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation menu', :js do
  let(:building) { FactoryBot.create(:building, name: 'Lewis Library') }
  let(:user) { FactoryBot.create(:user, :admin, building:) }

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

    it 'has a generic header for the application' do
      visit 'locker_renewal_messages/new'
      expect(page.find_by_id('appName').text).to eq('Princeton University Library Lockers and Study Rooms')
    end

    context 'when user is Firestone admin' do
      let(:building) { FactoryBot.create(:building, name: 'Firestone Library') }

      it 'shows study room admin options' do
        visit '/'
        expect(page).to have_content('Study Room Management')
      end

      it 'shows reports options' do
        visit '/'
        expect(page).to have_content('Reporting')
      end

      it 'shows renewal email admin options' do
        visit '/'
        click_button 'Locker Management'
        expect(page).to have_content('Renewal Emails')
      end
    end

    context 'when user is Lewis admin' do
      it 'does not show study room admin options' do
        visit '/'
        expect(page).not_to have_content('Study Room Management')
      end

      it 'does not show reports options' do
        visit '/'
        expect(page).not_to have_content('Reporting')
      end

      it 'does show renewal email admin options' do
        visit '/'
        click_button 'Locker Management'
        expect(page).to have_content('Renewal Emails')
      end
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
      let(:building) { FactoryBot.create(:building, name: 'Firestone Library') }

      it 'can see locker management navbar item' do
        visit '/'
        expect(page).to have_text('Locker Management')
      end
    end
  end

  context 'when user is not an admin' do
    let(:user) { FactoryBot.create(:user, admin: false) }

    it 'cannot see locker management navbar item' do
      visit '/'
      expect(page).not_to have_text('Locker Management')
    end
  end
end
