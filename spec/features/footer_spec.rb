# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Footer', :js do
  it 'displays on the home page' do
    visit '/'
    within('footer') do
      expect(page).to have_link('For Library Staff')
      expect(page).to have_link('Staff Directory')
      expect(page).to have_link('Library Jobs')
    end
  end
end
