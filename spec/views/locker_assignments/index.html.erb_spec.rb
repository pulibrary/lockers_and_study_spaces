# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/index', type: :view do
  let(:locker1) { FactoryBot.create :locker }
  let(:locker_application1) { FactoryBot.create :locker_application }
  let(:locker2) { FactoryBot.create :locker }
  let(:locker_application2) { FactoryBot.create :locker_application }
  before(:each) do
    assign(:locker_assignments, [
             FactoryBot.create(:locker_assignment,
                               locker_application: locker_application1,
                               locker: locker1),
             FactoryBot.create(:locker_assignment,
                               locker_application: locker_application2,
                               locker: locker2)
           ])
    assign(:pagy, instance_double('Pagy', prev: nil, next: nil, series: [], vars: { page: 1, items: 2, params: {} }))
  end

  it 'renders a list of locker_assignments' do
    render
    assert_select 'grid-item>strong', text: 'Start Date:'
    assert_select 'grid-item>strong', text: 'Expiration Date:'
    assert_select 'grid-item>strong', text: 'Released Date:'
    assert_select 'grid-item>strong', text: 'Applicant:'
    assert_select 'grid-item>strong', text: 'Location:'
    assert_select 'grid-item>span', text: locker_application1.uid
    assert_select 'grid-item>span', text: locker_application2.uid
    assert_select 'grid-item>span', text: locker1.location
    assert_select 'grid-item>span', text: locker2.location
  end
end
