# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Study Room Assign', type: :feature, js: true do
  let(:user) { FactoryBot.create :user, :admin }
  let!(:study_room1) { FactoryBot.create(:study_room, general_area: 'Classic Reading Room') }
  let!(:study_room2) { FactoryBot.create(:study_room, general_area: 'Classic Reading Room') }
  let!(:study_room3) { FactoryBot.create(:study_room) }
  let(:user1) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }

  before do
    sign_in user
  end

  it 'assigns study room locations by userid' do
    visit assign_users_study_rooms_path(general_area: 'Classic Reading Room')
    expect(page).to have_text('Assign Users to Study Room locations')
    expect(page).to have_text(study_room1.location)
    expect(page).to have_text(study_room2.location)
    expect(page).not_to have_text(study_room3.location)

    # fill in users
    fill_in "study_room_assignment_#{study_room1.id}_user_netid", with: user1.uid
    fill_in "study_room_assignment_#{study_room2.id}_user_netid", with: user2.uid

    expect { click_button 'Update Assignments' }.to change { StudyRoomAssignment.count }.by(2).and change { User.count }.by(0)
  end

  it 'assigns study room locations by userid and only creates assignments if needed' do
    StudyRoomAssignment.create!(user: user1, study_room: study_room1)
    visit assign_users_study_rooms_path(general_area: 'Classic Reading Room')

    expect(page).to have_text('Assign Users to Study Room locations')
    expect(page).to have_text(study_room1.location)
    expect(page).to have_text(study_room2.location)
    expect(page).not_to have_text(study_room3.location)

    # fill in users
    fill_in "study_room_assignment_#{study_room2.id}_user_netid", with: user2.uid

    expect { click_button 'Update Assignments' }.to change { StudyRoomAssignment.count }.by(1).and change { User.count }.by(0)
  end

  it 'creates a user if needed' do
    StudyRoomAssignment.create!(user: user1, study_room: study_room1)
    visit assign_users_study_rooms_path(general_area: 'Classic Reading Room')

    expect(page).to have_text('Assign Users to Study Room locations')
    expect(page).to have_text(study_room1.location)
    expect(page).to have_text(study_room2.location)
    expect(page).not_to have_text(study_room3.location)

    # fill in users
    fill_in "study_room_assignment_#{study_room2.id}_user_netid", with: 'abc123'

    expect { click_button 'Update Assignments' }.to change { StudyRoomAssignment.count }.by(1).and change { User.count }.by(1)
  end

  it 'unasigns a user if the uid is blank' do
    study_room_assignment = StudyRoomAssignment.create!(user: user1, study_room: study_room1)
    expect(study_room_assignment.reload.released_date).to be_nil
    visit assign_users_study_rooms_path(general_area: 'Classic Reading Room')

    expect(page).to have_text('Assign Users to Study Room locations')
    expect(page).to have_text(study_room1.location)
    expect(page).to have_text(study_room2.location)
    expect(page).not_to have_text(study_room3.location)

    # fill in users
    fill_in "study_room_assignment_#{study_room1.id}_user_netid", with: ''

    expect { click_button 'Update Assignments' }.to change { StudyRoomAssignment.count }.by(0).and change { User.count }.by(0)
    expect(study_room_assignment.reload.released_date).to eq(DateTime.now.to_date)
  end
end
