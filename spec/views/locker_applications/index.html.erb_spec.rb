# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/index' do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:building_one) { FactoryBot.create(:building, id: 1) }
  let(:building_two) { FactoryBot.create(:building, id: 2, name: 'Lewis Library') }

  before do
    building_one
    building_two
    assign(:locker_applications, [
             LockerApplication.create!(
               preferred_size: 2,
               preferred_general_area: 'Preferred General Area',
               accessible: false,
               semester: 'Semester',
               status_at_application: 'Status At Application',
               department_at_application: 'Department At Application',
               user: user1
             ),
             LockerApplication.create!(
               preferred_size: 2,
               preferred_general_area: 'Preferred General Area',
               accessible: false,
               semester: 'Semester',
               status_at_application: 'Status At Application',
               department_at_application: 'Department At Application',
               user: user2
             )
           ])
    assign(:pagy, instance_double(Pagy, prev: nil, next: nil, series: [], vars: { page: 1, items: 2, params: {} }))
  end

  it 'renders a list of locker_applications' do
    render
    assert_select 'lux-grid-item>strong', text: 'User:'
    assert_select 'lux-grid-item>strong', text: 'Department:'
    assert_select 'lux-grid-item>strong', text: 'Status:'
    assert_select 'lux-grid-item>strong', text: 'Semester:'
    assert_select 'lux-grid-item>span', text: user1.to_s
    assert_select 'lux-grid-item>span', text: user2.to_s
    assert_select 'lux-grid-item>span', text: 'Semester'.to_s, count: 2
    assert_select 'lux-grid-item>span', text: 'Status At Application'.to_s, count: 2
    assert_select 'lux-grid-item>span', text: 'Department At Application'.to_s, count: 2
  end
end
