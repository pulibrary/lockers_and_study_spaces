# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'lockers/index', type: :view do
  before(:each) do
    assign(:lockers, [
             Locker.create!(
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
             ),
             Locker.create!(
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
             )
           ])
    assign(:pagy, instance_double('Pagy', prev: nil, next: nil, series: [], vars: { page: 1, items: 2, params: {} }))
  end

  it 'renders a list of lockers' do
    render
    assert_select 'tr>td', text: 'Location'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'General Area'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: 'Notes'.to_s, count: 2
    assert_select 'tr>td', text: 'Combination'.to_s, count: 2
    assert_select 'tr>td', text: 'Code'.to_s, count: 2
    assert_select 'tr>td', text: 'Tag'.to_s, count: 2
    assert_select 'tr>td', text: 'Discs'.to_s, count: 2
    assert_select 'tr>td', text: 'Clutch'.to_s, count: 2
    assert_select 'tr>td', text: 'Hubpos'.to_s, count: 2
    assert_select 'tr>td', text: 'Key Number'.to_s, count: 2
    assert_select 'tr>td', text: 3.to_s, count: 2
  end
end
