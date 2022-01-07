# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_violations/new', type: :view do
  before(:each) do
    assign(:study_room_violation, FactoryBot.build(:study_room_violation))
  end

  it 'renders new violation form' do
    render

    assert_select 'form[action=?][method=?]', study_room_violations_path, 'post' do
      assert_select 'input[type=hidden][name=?]', 'study_room_violation[user_id]', count: 0
      assert_select 'input[type=hidden][name=?]', 'study_room_violation[study_room_id]', count: 0
      assert_select 'input-text[name=?]', 'study_room_violation[number_of_books]', count: 0
      expect(rendered).to match(/There is no user currently assigned to the study room!/)
    end
  end
end
