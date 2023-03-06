# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Application Assign', js: true do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:lewis) { FactoryBot.create(:building, name: 'Lewis Library', id: 2) }
  let(:locker_application) { FactoryBot.create(:locker_application, user: user1, preferred_general_area: 'A floor', complete: true) }
  let(:locker_application2) do
    FactoryBot.create(:locker_application, user: user1, building: lewis, preferred_size: 2, preferred_general_area: '4th floor',
                                           complete: true)
  end
  let(:incomplete_application) { FactoryBot.create(:locker_application, user: user2, complete: false) }
  let(:locker) { FactoryBot.create(:locker, floor: 'A floor') }
  let(:locker2) { FactoryBot.create(:locker, building: lewis, floor: '4th floor', location: '401', general_area: '4th floor', size: 2) }
  let(:locker3) { FactoryBot.create(:locker, building: lewis, floor: '3rd floor', location: '301', general_area: '3rd floor', size: 2) }

  before do
    sign_in user
    locker_application
    locker_application2
    incomplete_application
    locker
    locker2
    locker3
  end

  it 'does not show incomplete locker applications' do
    visit awaiting_assignment_locker_applications_path
    expect(page).to have_text(user1.uid)
    expect(page).not_to have_text(user2.uid)
  end

  it 'enables me to select a locker and assign it' do
    visit assign_locker_application_path(locker_application)
    expect(page).to have_text('Preferred general area: A floor')
    select locker.location, from: 'locker_assignment_locker_id'

    expect { click_button 'Submit Locker Assignment' }.to change { ActionMailer::Base.deliveries.count }.by(1)
    click_on 'Card for printing'
  end

  it 'has a unique <title>' do
    visit awaiting_assignment_locker_applications_path
    expect(page).to have_title('Applications awaiting assignment - Lockers and Study Spaces')
  end

  context 'with lewis_patrons on' do
    let(:lewis_admin) { FactoryBot.create(:user, :admin, building_id: lewis.id) }

    before do
      allow(Flipflop).to receive(:lewis_patrons?).and_return(true)
      allow(Flipflop).to receive(:lewis_staff?).and_return(true)
      sign_in lewis_admin
    end

    it 'Lewis assingment has preferred general area options' do
      visit assign_locker_application_path(locker_application2)
      expect(page).to have_text('Preferred general area: 4th floor')
      expect(page).to have_select 'Lockers Available in Preferred General Area/Size', options: ['401 (2\')']
    end
  end
end
