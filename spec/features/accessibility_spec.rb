# frozen_string_literal: true

require 'rails_helper'
require 'axe-rspec'

describe 'accessibility', :js do
  let(:firestone) { FactoryBot.create(:building, name: 'Firestone Library', id: 1) }
  let(:admin) { FactoryBot.create(:user, admin: true, building: firestone) }

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

  context 'when visiting the sign in page' do
    before do
      visit '/sign_in'
    end

    it 'complies with wcag' do
      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
    end
  end

  context 'when signed in as an admin' do
    before do
      sign_in admin
    end

    let(:locker_application) do
      FactoryBot.create(:locker_application, complete: true, accessibility_needs: ['Keyed entry (rather than combination)', 'Another need'])
    end

    context 'when editing new locker application' do
      it 'complies with wcag' do
        visit edit_locker_application_path(id: locker_application.id)
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end

    context 'when visiting lockers page' do
      it 'complies with wcag' do
        visit '/lockers'
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end

    context 'when visiting locker applications page' do
      it 'complies with wcag' do
        visit '/locker_applications'
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end

    context 'when visiting locker applications awaiting assignment page' do
      it 'complies with wcag' do
        visit '/locker_applications/awaiting_assignment'
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end

    context 'when visiting study rooms page' do
      it 'complies with wcag' do
        visit '/study_rooms'
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end

    context 'when visiting locker assignments page' do
      it 'complies with wcag' do
        visit '/locker_assignments'
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end

    context 'when creating a new locker' do
      it 'complies with wcag' do
        visit '/lockers/new'
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end

    context 'when visiting the locker renewal messages page' do
      it 'complies with wcag' do
        visit '/locker_renewal_messages'
        expect(page).to be_axe_clean
          .according_to(:wcag2a, :wcag2aa, :wcag21a, :wcag21aa)
      end
    end
  end
end
