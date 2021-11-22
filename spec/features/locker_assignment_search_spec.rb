# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Assignment Search', type: :feature, js: true do
  let(:user) { FactoryBot.create :user, :admin }
  let(:locker_application1) { FactoryBot.create(:locker_application, status_at_application: 'junior') }
  let(:locker_application2) { FactoryBot.create(:locker_application) }
  let(:locker1) { FactoryBot.create(:locker, floor: 'A floor') }
  let(:locker2) { FactoryBot.create(:locker) }

  let(:locker_assignment1) { FactoryBot.create(:locker_assignment, locker_application: locker_application1, locker: locker1) }
  let(:locker_assignment2) { FactoryBot.create(:locker_assignment, locker_application: locker_application2, locker: locker2) }

  before do
    sign_in user
    locker_assignment1
    locker_assignment2
  end

  it 'enables me to search by userid' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).to have_text('Search by user netid')

    fill_in 'query_uid', with: locker_assignment1.uid
    click_button 'search_sumbit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by applicant status' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)

    select 'junior', from: :query_status_at_application
    click_button 'filter_sumbit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by locker floor' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)

    select 'A floor', from: :query_floor
    click_button 'filter_sumbit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by locker general area' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)

    select locker2.general_area, from: :query_general_area
    click_button 'filter_sumbit'

    expect(page).not_to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
  end
end
