# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledMessage, :js do
  let(:firestone) { FactoryBot.create(:building, id: 1) }
  let(:lewis) { FactoryBot.create(:building, name: 'Lewis Library', id: 2) }
  let(:firestone_admin) { FactoryBot.create(:user, :admin, building: firestone) }
  let(:lewis_admin) { FactoryBot.create(:user, :admin, building: lewis) }

  let(:yesterday_firestone) do
    described_class.create!(schedule: Date.yesterday, applicable_range: Date.yesterday..Date.yesterday, building_id: firestone.id)
  end
  let(:today_firestone) do
    described_class.create!(schedule: Time.zone.today, applicable_range: Time.zone.today..Time.zone.today, building_id: firestone.id)
  end
  let(:tomorrow_firestone) { described_class.create!(schedule: Date.tomorrow, applicable_range: Date.tomorrow..Date.tomorrow, building_id: firestone.id) }
  let(:yesterday_lewis) { described_class.create!(schedule: Date.yesterday, applicable_range: Date.yesterday..Date.yesterday, building_id: lewis.id) }
  let(:today_lewis) { described_class.create!(schedule: Time.zone.today, applicable_range: Time.zone.today..Time.zone.today, building_id: lewis.id) }

  before do
    yesterday_firestone
    today_firestone
    tomorrow_firestone
    yesterday_lewis
    today_lewis
  end

  context 'when a Firestone admin' do
    before do
      sign_in firestone_admin
    end

    it 'only displays the scheduled messages for Firestone' do
      visit '/locker_renewal_messages'
      expect(page).to have_link('Show', count: 3)
    end

    it 'can create a new Firestone scheduled message' do
      visit '/locker_renewal_messages/new'

      fill_in 'schedule', with: (Time.zone.today + 1.day).strftime('%m/%d/%y')
      fill_in 'applicable_range', with: "#{(Time.zone.today + 1.day).strftime('%m/%d/%y')} - #{(Time.zone.today + 2.days).strftime('%m/%d/%y')}"

      expect do
        click_button 'Submit'
        expect(page).to have_current_path %r{/locker_renewal_messages/\d+$}
      end.to change(described_class, :count).by(1)
    end

    it 'can delete a Firestone scheduled message' do
      visit "/locker_renewal_messages/#{described_class.last.id}/edit"

      expect do
        click_link 'Remove from schedule'
        expect(page).to have_current_path '/locker_renewal_messages'
      end.to change(described_class, :count).by(-1)
    end
  end

  context 'when a Lewis admin' do
    before do
      allow(Flipflop).to receive_messages(lewis_patrons?: true, lewis_staff?: true)
      sign_in lewis_admin
    end

    it 'only displays the scheduled messages for Lewis' do
      visit '/locker_renewal_messages'
      expect(page).to have_link('Show', count: 2)
    end

    it 'can create a new Lewis scheduled message' do
      visit '/locker_renewal_messages/new'

      fill_in 'schedule', with: (Time.zone.today + 1.day).strftime('%m/%d/%y')
      fill_in 'applicable_range', with: "#{(Time.zone.today + 1.day).strftime('%m/%d/%y')} - #{(Time.zone.today + 2.days).strftime('%m/%d/%y')}"

      expect do
        click_button 'Submit'
        expect(page).to have_current_path %r{/locker_renewal_messages/\d+$}
      end.to change(described_class, :count).by(1)
    end

    it 'can delete a Lewis scheduled message' do
      visit "/locker_renewal_messages/#{described_class.last.id}/edit"

      expect do
        click_link 'Remove from schedule'
        expect(page).to have_current_path '/locker_renewal_messages'
      end.to change(described_class, :count).by(-1)
    end
  end
end
