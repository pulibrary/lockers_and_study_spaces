# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_violations/show', type: :view do
  before do
    @study_room_violation = assign(:study_room_violations, FactoryBot.create(:study_room_violation, number_of_books: 5))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/5/)
  end
end
