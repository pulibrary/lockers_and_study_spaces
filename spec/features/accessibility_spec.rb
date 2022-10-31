# frozen_string_literal: true

require 'rails_helper'
require 'axe-rspec'

describe 'accessibility', type: :feature, js: true do
  context 'when visiting the home page' do
    before do
      visit '/'
    end

    it 'complies with wcag' do
      expect(page).to be_axe_clean
        .according_to(:wcag2a, :wcag2aa)
        .skipping(:list)
    end
  end
end
