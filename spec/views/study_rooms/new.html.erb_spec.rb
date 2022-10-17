# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_rooms/new', type: :view do
  before do
    assign(:study_room, StudyRoom.new(
                          location: 'MyString',
                          general_area: 'MyString',
                          notes: 'MyString'
                        ))
  end

  it 'renders new study_room form' do
    render

    assert_select 'form[action=?][method=?]', study_rooms_path, 'post' do
      assert_select 'input[name=?]', 'study_room[location]'

      assert_select 'input[name=?]', 'study_room[general_area]'

      assert_select 'input[name=?]', 'study_room[notes]'
    end
  end
end
