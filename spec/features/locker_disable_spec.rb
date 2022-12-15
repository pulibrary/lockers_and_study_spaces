# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locker disable/enable', js: true do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:locker1) { FactoryBot.create(:locker) }
  let(:locker2) { FactoryBot.create(:locker) }

  before do
    sign_in user
    locker1
    locker2
  end

  it 'allows me to disable and enable a locker' do
    visit '/lockers'
    expect(page).to have_text(locker1.location)
    expect(page).to have_text(locker2.location)
    click_link "disable_#{locker1.id}"

    expect(page).to have_text(locker1.location)
    expect(page).to have_text(locker2.location)
    click_link "enable_#{locker1.id}"
  end
end
