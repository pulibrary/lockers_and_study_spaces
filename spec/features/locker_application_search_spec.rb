# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Application Search', js: true do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:user3) { FactoryBot.create(:user) }
  let(:locker_application1) { FactoryBot.create(:locker_application, user: user1, complete: true) }
  let(:locker_application2) { FactoryBot.create(:locker_application, user: user2, complete: true) }

  before do
    sign_in user
    locker_application1
    FactoryBot.create(:locker_assignment, locker_application: locker_application2)
  end

  it 'enables me to search by userid' do
    visit '/locker_applications'
    expect(page).to have_text(user1.uid)
    expect(page).to have_text(user2.uid)
    expect(page).to have_text('Search by user netid')

    fill_in 'search', with: user1.uid
    click_button 'search_submit'

    expect(page).to have_text(user1.uid)
    expect(page).not_to have_text(user2.uid)
  end

  context 'with incomplete locker applications' do
    let(:incomplete_application) { FactoryBot.create(:locker_application, user: user3, complete: false) }

    before do
      incomplete_application
    end

    it 'does not display incomplete locker applications' do
      visit '/locker_applications'
      expect(page).to have_text(user1.uid)
      expect(page).to have_text(user2.uid)
      expect(page).not_to have_text(user3.uid)

      fill_in 'search', with: user3.uid
      click_button 'search_submit'

      expect(page).not_to have_text(user1.uid)
      expect(page).not_to have_text(user2.uid)
      expect(page).not_to have_text(user3.uid)
    end
  end
end
