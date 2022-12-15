# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_violations/show' do
  before do
    @locker_violation = assign(:locker_violations, FactoryBot.create(:locker_violation, number_of_books: 5))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/5/)
  end
end
