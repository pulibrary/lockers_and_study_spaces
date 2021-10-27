# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/index', type: :view do
  let(:user1) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user }
  before(:each) do
    assign(:locker_applications, [
             LockerApplication.create!(
               preferred_size: 2,
               preferred_general_area: 'Preferred General Area',
               accessible: false,
               semester: 'Semester',
               staus_at_application: 'Staus At Application',
               department_at_application: 'Department At Application',
               user: user1
             ),
             LockerApplication.create!(
               preferred_size: 2,
               preferred_general_area: 'Preferred General Area',
               accessible: false,
               semester: 'Semester',
               staus_at_application: 'Staus At Application',
               department_at_application: 'Department At Application',
               user: user2
             )
           ])
  end

  it 'renders a list of locker_applications' do
    render
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'Preferred General Area'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: 'Semester'.to_s, count: 2
    assert_select 'tr>td', text: 'Staus At Application'.to_s, count: 2
    assert_select 'tr>td', text: 'Department At Application'.to_s, count: 2
    assert_select 'tr>td', text: user1.to_s
    assert_select 'tr>td', text: user2.to_s
  end
end
