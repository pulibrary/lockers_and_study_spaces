# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Assignment Search', :js do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:locker_application1) { FactoryBot.create(:locker_application, status_at_application: 'junior', complete: true) }
  let(:locker_application2) { FactoryBot.create(:locker_application, complete: true) }
  let(:locker_application3) { FactoryBot.create(:locker_application, complete: true) }
  let(:locker1) { FactoryBot.create(:locker, floor: 'A floor') }
  let(:locker2) { FactoryBot.create(:locker) }
  let(:locker3) { FactoryBot.create(:locker) }

  let(:yesterday) { DateTime.yesterday.to_date }
  let(:next_year) { DateTime.now.to_date.next_year }
  let(:locker_assignment1) do
    FactoryBot.create(:locker_assignment, locker_application: locker_application1, locker: locker1, expiration_date: next_year)
  end
  let(:locker_assignment2) do
    FactoryBot.create(:locker_assignment, locker_application: locker_application2, locker: locker2, expiration_date: next_year)
  end
  let(:locker_assignment3) do
    FactoryBot.create(:locker_assignment, locker_application: locker_application3, locker: locker3, expiration_date: yesterday)
  end

  before do
    sign_in user
    locker_assignment1
    locker_assignment2
    locker_assignment3
  end

  it 'enables me to search by userid' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
    expect(page).to have_text('Search by user netid')

    fill_in 'query_uid', with: locker_assignment1.uid
    click_button 'search_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
  end

  it 'enables me to filter by applicant status' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)

    select 'junior', from: :query_status_at_application
    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
  end

  it 'enables me to filter by locker floor' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)

    select 'A floor', from: :query_floor
    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
  end

  it 'enables me to filter by locker general area' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)

    select locker2.general_area, from: :query_general_area
    click_button 'filter_submit'

    expect(page).not_to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
  end

  it 'enables me to filter by locker department_at_application' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)

    select locker_application1.department_at_application, from: :query_department_at_application
    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
  end

  # inactive assignments filtered by default. will uncheck and show all
  it 'enables me to filter by active assignments' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
    uncheck :query_active
    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).to have_text(locker_assignment3.uid)
  end

  # We are testing a range of dates because Lux has a bug with typing in dates - see https://github.com/pulibrary/lux/issues/395
  it 'enables me to filter by expiration date' do
    js_date_format = '%m/%d/%Y'

    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(locker_assignment3.expiration_date).to eq(yesterday)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)
    fill_in 'query_daterange',
            with: "#{(next_year - 1.day).strftime(js_date_format)} - #{(next_year + 1.day).strftime(js_date_format)}"

    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    expect(page).not_to have_text(locker_assignment3.uid)

    uncheck :query_active
    fill_in 'query_daterange',
            with: "#{(yesterday - 1.day).strftime(js_date_format)} - #{(yesterday + 1.day).strftime(js_date_format)}"

    click_button 'filter_submit'

    expect(page).not_to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
    expect(page).to have_text(locker_assignment3.uid)
  end
end
