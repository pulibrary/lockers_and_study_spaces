# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_assignments/index', type: :view do
  let(:user) { FactoryBot.create :user }
  let(:study_room) { FactoryBot.create :study_room }

  before(:each) do
    assign(:study_room_assignments, [
             StudyRoomAssignment.create!(
               user: user,
               study_room: study_room
             ),
             StudyRoomAssignment.create!(
               user: user,
               study_room: study_room
             )
           ])
    assign(:pagy, instance_double('Pagy', prev: nil, next: nil, series: [], vars: { page: 1, items: 2, params: {} }))
  end

  it 'renders a list of study_room_assignments' do
    render
    assert_select 'tr>td', text: user.to_s, count: 2
    assert_select 'tr>td', text: study_room.to_s, count: 2
  end
end
