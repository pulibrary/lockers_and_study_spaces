# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_assignments/new' do
  before do
    assign(:study_room_assignment, StudyRoomAssignment.new(
                                     user: nil,
                                     study_room: nil
                                   ))
  end

  it 'renders new study_room_assignment form' do
    render

    assert_select 'form[action=?][method=?]', study_room_assignments_path, 'post' do
      assert_select 'input[name=?]', 'study_room_assignment[user_id]'

      assert_select 'input[name=?]', 'study_room_assignment[study_room_id]'
    end
  end
end
