# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Footer', js: true do
  it 'displays on the home page' do
    visit '/'
    within('footer') do
      expect(page).to have_link('Databases')
      expect(page).to have_link('Catalog')
      expect(page).to have_link('Accessibility')
    end
  end
end
