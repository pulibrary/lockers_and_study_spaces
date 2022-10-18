# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_rooms/edit', type: :view do
  before do
    @study_room = assign(:study_room, StudyRoom.create!(
                                        location: 'MyString',
                                        general_area: 'MyString',
                                        notes: 'MyString'
                                      ))
  end

  it 'renders the edit study_room form' do
    render

    assert_select 'form[action=?][method=?]', study_room_path(@study_room), 'post' do
      assert_select 'input[name=?]', 'study_room[location]'

      assert_select 'input[name=?]', 'study_room[general_area]'

      assert_select 'input[name=?]', 'study_room[notes]'
    end
  end
end
