# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_rooms/show' do
  before do
    @study_room = assign(:study_room, StudyRoom.create!(
                                        location: 'Location',
                                        general_area: 'General Area',
                                        notes: 'Notes'
                                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to include('Location')
    expect(rendered).to include('General Area')
    expect(rendered).to include('Notes')
  end
end
