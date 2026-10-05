# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'lockers/show' do
  before do
    @locker = assign(:locker, Locker.create!(
                                location: 'Location',
                                size: 2,
                                general_area: 'General Area',
                                accessible: false,
                                notes: 'Notes',
                                combination: 'Combination',
                                code: 'Code',
                                tag: 'Tag',
                                discs: 'Discs',
                                clutch: 'Clutch',
                                hubpos: 'Hubpos',
                                key_number: 'Key Number',
                                floor: 3
                              ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to include('Location')
    expect(rendered).to include('2')
    expect(rendered).to include('General Area')
    expect(rendered).to include('false')
    expect(rendered).to include('Notes')
    expect(rendered).to include('Combination')
    expect(rendered).to include('Code')
    expect(rendered).to include('Tag')
    expect(rendered).to include('Discs')
    expect(rendered).to include('Clutch')
    expect(rendered).to include('Hubpos')
    expect(rendered).to include('Key Number')
    expect(rendered).to include('3')
  end

  context 'An assigned locker' do
    let(:locker_assignment) { FactoryBot.create(:locker_assignment, locker: @locker) }

    it 'renders a link to the assignment' do
      locker_assignment
      render
      expect(rendered).to match(/#{locker_assignment_path(locker_assignment)}/)
    end
  end
end
