# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_violations/index', type: :view do
  before(:each) do
    assign(:study_room_violations,
           [FactoryBot.create(:study_room_violation, number_of_books: 5), FactoryBot.create(:study_room_violation, number_of_books: 7)])
  end

  it 'renders a list of study_room_violations' do
    render
    assert_select 'tr>td', text: 5.to_s, count: 1
    assert_select 'tr>td', text: 7.to_s, count: 1
  end
end
