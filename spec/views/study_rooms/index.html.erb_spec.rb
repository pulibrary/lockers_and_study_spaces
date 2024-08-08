# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_rooms/index' do
  before do
    @study_rooms = assign(:study_rooms, [
                            StudyRoom.create!(
                              location: 'Location',
                              general_area: 'General Area',
                              notes: 'Notes'
                            ),
                            StudyRoom.create!(
                              location: 'Location',
                              general_area: 'General Area',
                              notes: 'Notes'
                            )
                          ])
    assign(:pagy, instance_double(Pagy, prev: nil, next: nil, series: [], vars: { page: 1, items: 2, params: {} }))
  end

  it 'renders a list of study rooms' do
    render

    assert_select 'lux-grid-item>strong', text: 'Location:'
    assert_select 'lux-grid-item>strong', text: 'General Area:'
    assert_select 'lux-grid-item>span', text: 'Location'.to_s, count: 2
    assert_select 'lux-grid-item>span', text: 'General Area'.to_s, count: 2
    expect(rendered).to match(/#{study_room_path(@study_rooms[0])}/)
    expect(rendered).to match(/#{edit_study_room_path(@study_rooms[0])}/)
    expect(rendered).to match(/#{study_room_path(@study_rooms[1])}/)
    expect(rendered).to match(/#{edit_study_room_path(@study_rooms[1])}/)
  end
end
