# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Application Assign', type: :feature, js: true do
  let(:user) { FactoryBot.create :user, :admin }
  let(:user1) { FactoryBot.create :user }
  let(:locker_application) { FactoryBot.create(:locker_application, user: user1, preferred_general_area: 'A floor') }
  let(:locker) { FactoryBot.create(:locker, floor: 'A floor') }

  before do
    sign_in user
    locker_application
    locker
  end

  it 'enables me to search by userid' do
    visit assign_locker_application_path(locker_application)
    expect(page).to have_text('Preferred general area: A floor')
    select locker.location, from: 'locker_assignment_locker_id'

    expect { click_button 'Submit Locker Assignment' }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
