# frozen_string_literal: true

require 'rails_helper'
require 'axe-rspec'

describe 'accessibility', :js do
  let(:admin) { FactoryBot.create(:user, admin: true) }
  let(:firestone) { FactoryBot.create(:building, name: 'Firestone Library', id: 1) }

  before do
    firestone
  end

  context 'when visiting the home page' do
    before do
      visit '/'
    end

    it 'complies with wcag' do
      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa)
        .skipping(:list)
    end
  end

  context 'when creating new locker application' do
    before do
      sign_in admin
    end

    let(:locker_application) do
      FactoryBot.create(:locker_application, complete: true, accessibility_needs: ['Keyed entry (rather than combination)', 'Another need'])
    end

    it 'complies with wcag' do
      visit edit_locker_application_path(id: locker_application.id)
      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
    end
  end

  context 'when visiting the sign in page' do
    before do
      visit '/sign_in'
    end

    it 'complies with wcag' do
      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
    end
  end
end
