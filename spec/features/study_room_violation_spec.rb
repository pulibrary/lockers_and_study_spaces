# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Study Room Violation', :js do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:study_room_assignment) { FactoryBot.create(:study_room_assignment) }

  before do
    sign_in user
    study_room_assignment
  end

  it 'enables me to record a study room violation' do
    visit study_rooms_path
    expect(page).to have_text(study_room_assignment.study_room.location)
    click_link 'Record Violation'
    fill_in :study_room_violation_number_of_books, with: 2
    expect do
      click_button 'Record Violation'
      expect(page).to have_current_path %r{/study_room_violations/\d+}
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
