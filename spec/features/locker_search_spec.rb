# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker Search', js: true do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:locker1) { FactoryBot.create(:locker) }
  let(:locker2) { FactoryBot.create(:locker) }

  before do
    sign_in user
    locker1
    locker2
  end

  it 'enables me to search by location' do
    visit '/lockers'
    expect(page).to have_text(locker1.location)
    expect(page).to have_text(locker2.location)
    expect(page).to have_text('Search by location')

    fill_in 'search', with: locker1.location
    click_button 'search_submit'

    expect(page).to have_text(locker1.location)
    expect(page).not_to have_text(locker2.location)
  end
end
