# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/index', type: :view do
  let(:locker1) { FactoryBot.create :locker }
  let(:locker_application1) { FactoryBot.create :locker_application }
  let(:locker2) { FactoryBot.create :locker }
  let(:locker_application2) { FactoryBot.create :locker_application }
  before(:each) do
    assign(:locker_assignments, [
             LockerAssignment.create!(
               locker_application: locker_application1,
               locker: locker1,
               start_date: DateTime.current.to_date
             ),
             LockerAssignment.create!(
               locker_application: locker_application2,
               locker: locker2,
               start_date: DateTime.current.to_date
             )
           ])
  end

  it 'renders a list of locker_assignments' do
    render
    assert_select 'tr>td', text: locker_application1.applicant.to_s
    assert_select 'tr>td', text: locker_application2.applicant.to_s
    assert_select 'tr>td', text: locker1.location
    assert_select 'tr>td', text: locker2.location
  end
end
