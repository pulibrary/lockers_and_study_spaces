# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Violation', :js do
  let(:firestone) { FactoryBot.create(:building, id: 1) }
  let(:user) { FactoryBot.create(:user, :admin, building: firestone) }
  let(:locker_assignment) { FactoryBot.create(:locker_assignment) }

  before do
    sign_in user
    locker_assignment
  end

  it 'enables me to record a locker violation' do
    visit lockers_path
    expect(page).to have_text(locker_assignment.locker.location)
    click_link 'Record Violation'
    fill_in :locker_violation_number_of_books, with: 2
    expect do
      click_button 'Record Locker Violation'
      expect(page).to have_current_path %r{/locker_violations/\d+}
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
