# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Study Room Search', type: :feature, js: true do
  let(:user) { FactoryBot.create :user, :admin }
  let(:study_room1) { FactoryBot.create(:study_room) }
  let(:study_room2) { FactoryBot.create(:study_room) }

  before do
    sign_in user
    study_room1
    study_room2
  end

  it 'enables me to search by location' do
    visit '/study_rooms'
    expect(page).to have_text(study_room1.location)
    expect(page).to have_text(study_room2.location)
    expect(page).to have_text('Search by location')

    fill_in 'search', with: study_room1.location
    click_button 'search_sumbit'

    expect(page).to have_text(study_room1.location)
    expect(page).not_to have_text(study_room2.location)
  end
end
