# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Application Assign', js: true do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:locker_application) { FactoryBot.create(:locker_application, user: user1, preferred_general_area: 'A floor', complete: true) }
  let(:incomplete_application) { FactoryBot.create(:locker_application, user: user2, complete: false) }
  let(:locker) { FactoryBot.create(:locker, floor: 'A floor') }

  before do
    sign_in user
    locker_application
    incomplete_application
    locker
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
end
