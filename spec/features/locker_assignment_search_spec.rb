# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Assignment Search', type: :feature, js: true do
  let(:user) { FactoryBot.create :user, :admin }
  let(:locker_application1) { FactoryBot.create(:locker_application, status_at_application: 'junior') }
  let(:locker_application2) { FactoryBot.create(:locker_application) }
  let(:locker1) { FactoryBot.create(:locker, floor: 'A floor') }
  let(:locker2) { FactoryBot.create(:locker) }

  let(:locker_assignment1) do
    FactoryBot.create(:locker_assignment, locker_application: locker_application1, locker: locker1, expiration_date: DateTime.yesterday.to_date)
  end
  let(:locker_assignment2) do
    FactoryBot.create(:locker_assignment, locker_application: locker_application2, locker: locker2, expiration_date: DateTime.now.to_date.next_year)
  end

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
    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by locker floor' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)

    select 'A floor', from: :query_floor
    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by locker general area' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)

    select locker2.general_area, from: :query_general_area
    click_button 'filter_submit'

    expect(page).not_to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by locker department_at_application' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)

    select locker_application1.department_at_application, from: :query_department_at_application
    click_button 'filter_submit'

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by active assignments' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    check :query_active
    click_button 'filter_submit'

    expect(page).not_to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
  end

  it 'enables me to filter by expiration date' do
    visit '/locker_assignments'
    expect(page).to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)
    js_date_format = '%m/%d/%Y'
    fill_in 'query_daterange',
            with: "#{locker_assignment2.expiration_date.strftime(js_date_format)} - #{locker_assignment2.expiration_date.strftime(js_date_format)}"

    check :query_active
    click_button 'filter_submit'

    expect(page).not_to have_text(locker_assignment1.uid)
    expect(page).to have_text(locker_assignment2.uid)

    fill_in 'query_daterange',
            with: "#{locker_assignment1.expiration_date.strftime(js_date_format)} - #{locker_assignment1.expiration_date.strftime(js_date_format)}"

    expect(page).to have_text(locker_assignment1.uid)
    expect(page).not_to have_text(locker_assignment2.uid)
  end
end
