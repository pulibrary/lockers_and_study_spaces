# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_assignments/edit' do
  let(:user) { FactoryBot.create(:user) }
  let(:study_room) { FactoryBot.create(:study_room) }

  before do
    @study_room_assignment = assign(:study_room_assignment, StudyRoomAssignment.create!(
                                                              user:,
                                                              study_room:
                                                            ))
  end

  it 'renders the edit study_room_assignment form' do
    render

    assert_select 'form[action=?][method=?]', study_room_assignment_path(@study_room_assignment), 'post' do
      assert_select 'input[name=?]', 'study_room_assignment[user_id]'

      assert_select 'input[name=?]', 'study_room_assignment[study_room_id]'
    end
  end
end
