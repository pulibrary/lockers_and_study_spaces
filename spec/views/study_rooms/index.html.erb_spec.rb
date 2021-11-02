# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_rooms/index', type: :view do
  before(:each) do
    assign(:study_rooms, [
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
    assign(:pagy, instance_double('Pagy', prev: nil, next: nil, series: [], vars: { page: 1, items: 2, params: {} }))
  end

  it 'renders a list of study_rooms' do
    render
    assert_select 'tr>td', text: 'Location'.to_s, count: 2
    assert_select 'tr>td', text: 'General Area'.to_s, count: 2
    assert_select 'tr>td', text: 'Notes'.to_s, count: 2
  end
end
