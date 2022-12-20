# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/index' do
  let(:locker1) { FactoryBot.create(:locker) }
  let(:locker_application1) { FactoryBot.create(:locker_application) }
  let(:locker2) { FactoryBot.create(:locker) }
  let(:locker_application2) { FactoryBot.create(:locker_application) }
  let(:building) { FactoryBot.create(:building, name: 'Library of Alexandria') }
  let(:user) { FactoryBot.create(:user, building:) }

  before do
    assign(:locker_assignments, [
             FactoryBot.create(:locker_assignment,
                               locker_application: locker_application1,
                               locker: locker1),
             FactoryBot.create(:locker_assignment,
                               locker_application: locker_application2,
                               locker: locker2)
           ])
    assign(:pagy, instance_double(Pagy, prev: nil, next: nil, series: [], vars: { page: 1, items: 2, params: {} }))
    allow(view).to receive(:current_user).and_return(user)
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

  it "has a header containing the name of the admin user's library" do
    render
    assert_select 'heading', text: 'Library of Alexandria Locker Assignments'
  end
end
