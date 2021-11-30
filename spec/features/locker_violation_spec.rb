# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Application Assign', type: :feature, js: true do
  let(:user) { FactoryBot.create :user, :admin }
  let(:locker_assignment) { FactoryBot.create(:locker_assignment) }

  before do
    sign_in user
    locker_assignment
  end

  it 'enables me to search by userid' do
    visit lockers_path
    expect(page).to have_text(locker_assignment.locker.location)
    click_on 'Record LockerViolation'
    fill_in :locker_violation_number_of_books, with: 2
    expect { click_button 'Record Locker Violation' }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
