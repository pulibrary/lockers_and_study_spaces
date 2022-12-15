# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'study_room_assignments/show' do
  let(:user) { FactoryBot.create(:user) }
  let(:study_room) { FactoryBot.create(:study_room) }

  before do
    @study_room_assignment = assign(:study_room_assignment, StudyRoomAssignment.create!(
                                                              user:,
                                                              study_room:
                                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
