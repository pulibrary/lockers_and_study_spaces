# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'lockers/show', type: :view do
  before(:each) do
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
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/General Area/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Notes/)
    expect(rendered).to match(/Combination/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Tag/)
    expect(rendered).to match(/Discs/)
    expect(rendered).to match(/Clutch/)
    expect(rendered).to match(/Hubpos/)
    expect(rendered).to match(/Key Number/)
    expect(rendered).to match(/3/)
  end
end
