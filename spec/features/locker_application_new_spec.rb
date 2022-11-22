# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Application New', type: :feature, js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:building_one) { FactoryBot.create(:building, id: 1) }
  let(:building_two) { FactoryBot.create(:building, name: 'Lewis Library', id: 2) }

  before do
    building_one
    building_two
  end

  context 'with an authenticated user' do
    before do
      sign_in user
    end

    context 'with lewis_patrons on' do
      before do
        allow(Flipflop).to receive(:lewis_patrons?).and_return(true)
      end

      it 'has a two step application process' do
        visit root_path
        expect(page).to have_select('Library', options: ['Select Library', 'Firestone Library', 'Lewis Library'])
        select('Firestone Library', from: :locker_application_building_id)
        expect(page).to have_button('Next')
        # Submit library as first step
        expect do
          click_button('Next')
        end.to change(LockerApplication, :count)
        expect(page).to have_current_path(edit_locker_application_path(id: LockerApplication.last.id), ignore_query: true)
      end

      it 'can apply for a new locker' do
        visit root_path
        select('Firestone Library', from: :locker_application_building_id)
        click_button('Next')
        new_application = LockerApplication.last
        expect(page).to have_content('Firestone Locker Application')
        expect(page).to have_select('Preferred Size', options: %w[4-foot 6-foot])
        expect(page).to have_select('Preferred Floor', options: ['No preference', 'A floor', 'B floor', 'C floor', '2nd floor', '3rd floor'])
        expect(page).to have_select('Semester of Occupancy', options: ['Fall & Spring', 'Spring Only'])
        expect(page).to have_unchecked_field('Accessible')
        expect(page).to have_select('Student/Staff/Faculty Status', options: %w[senior junior graduate faculty staff])
        expect(page).to have_field('Department')
        uid_field = page.find('#locker_application_user_uid', visible: false)
        expect(uid_field.value).to eq(user.uid)
        expect(page).to have_button('Submit Locker Application')
        # Add some values to form
        select('4-foot', from: :locker_application_preferred_size)
        expect(new_application.reload.complete).to be false
        click_button('Submit Locker Application')
        expect(new_application.reload.preferred_size).to eq(4)
        expect(new_application.reload.complete).to be true
        expect(page).to have_current_path(locker_application_path(new_application))
      end
    end

    context 'with lewis_patrons off' do
      before do
        allow(Flipflop).to receive(:lewis_patrons?).and_return(false)
      end

      it 'has a single step application process' do
        visit root_path
        expect(page).to have_content('Firestone Locker Application')
        expect(page).to have_select('Preferred Size', options: %w[4-foot 6-foot])
        expect(page).to have_select('Preferred Floor', options: ['No preference', 'A floor', 'B floor', 'C floor', '2nd floor', '3rd floor'])
        expect(page).to have_select('Semester of Occupancy', options: ['Fall & Spring', 'Spring Only'])
        expect(page).to have_unchecked_field('Accessible')
        expect(page).to have_select('Student/Staff/Faculty Status', options: %w[senior junior graduate faculty staff])
        expect(page).to have_field('Department')
        expect(page).to have_button('Submit Locker Application')
        expect do
          click_button('Submit Locker Application')
        end.to change(LockerApplication, :count)
        expect(page).to have_current_path(locker_application_path(id: LockerApplication.last.id))
      end
    end
  end

  context 'with an administrator' do
    let(:admin) { FactoryBot.create(:user, admin: true) }

    before do
      sign_in admin
    end

    context 'with lewis_patrons on' do
      before do
        allow(Flipflop).to receive(:lewis_patrons?).and_return(true)
      end

      context 'with an existing user' do
        before do
          user
        end

        it 'can assign the application to an existing user' do
          visit root_path
          select('Firestone Library', from: :locker_application_building_id)
          click_button('Next')
          new_application = LockerApplication.last
          expect(new_application.user).to eq(admin)
          expect(page).to have_content('Firestone Locker Application')
          expect(page).to have_field('Applicant Netid', with: admin.uid)
          fill_in('Applicant Netid', with: user.uid, fill_options: { clear: :backspace })
          check('Accessible')
          expect(page).to have_field('Applicant Netid', with: user.uid)
          click_button('Submit Locker Application')
          expect(page).not_to have_content('User must exist')
          expect(page).to have_current_path(locker_application_path(new_application))
          expect(new_application.reload.user).to eq(user)
        end
      end

      context 'with a valid user that does not exist yet' do
        it 'can create and assign an application to a new user' do
          visit root_path
          select('Firestone Library', from: :locker_application_building_id)
          click_button('Next')
          new_application = LockerApplication.last
          expect(new_application.user).to eq(admin)
          expect(page).to have_content('Firestone Locker Application')
          expect(page).to have_field('Applicant Netid', with: admin.uid)
          fill_in('Applicant Netid', with: 'arbitrary netid', fill_options: { clear: :backspace })
          check('Accessible')
          expect(page).to have_field('Applicant Netid', with: 'arbitrary netid')
          click_button('Submit Locker Application')
          expect(page).not_to have_content('User must exist')
          expect(page).to have_current_path(locker_application_path(new_application))
        end
      end
    end

    context 'with lewis_patrons off' do
      before do
        allow(Flipflop).to receive(:lewis_patrons?).and_return(false)
      end

      it 'can create and assign an application to a new user' do
        visit root_path
        expect(page).to have_content('Firestone Locker Application')
        expect(page).to have_field('Applicant Netid',  with: admin.uid)
        fill_in('Applicant Netid', with: 'arbitrary netid', fill_options: { clear: :backspace })
        check('Accessible')
        expect(page).to have_field('Applicant Netid', with: 'arbitrary netid')
        click_button('Submit Locker Application')
        new_application = LockerApplication.last
        expect(page).not_to have_content('User must exist')
        expect(page).to have_current_path(locker_application_path(new_application))
        new_user = User.last
        expect(new_application.user).to eq(new_user)
      end
    end
  end

  context 'with an unauthenticated user' do
    it 'redirects the user to the sign in' do
      visit root_path
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
      expect(page).to have_link('Login with NetID')
      click_link('Login with NetID')
      expect(page).to have_current_path(root_path, ignore_query: true)
    end
  end
end
