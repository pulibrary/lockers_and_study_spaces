# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/assign', type: :view do
  let(:locker_application) { FactoryBot.create :locker_application }
  before(:each) do
    assign(:locker_application, locker_application)
    assign(:locker_assignment, LockerAssignment.new(
                                 locker_application: locker_application,
                                 locker: nil,
                                 start_date: DateTime.current.to_date
                               ))
  end

  it 'renders new locker_assignment form' do
    render
    expect(rendered).to match(/#{locker_application.preferred_size}/)
    expect(rendered).to match(/#{locker_application.preferred_general_area}/)
    expect(rendered).to match(/#{locker_application.uid}/)
    assert_select 'form[action=?][method=?]', locker_assignments_path, 'post' do
      assert_select 'select[name=?]', 'locker_assignment[start_date(1i)]'
      assert_select 'select[name=?]', 'locker_assignment[start_date(2i)]'
      assert_select 'select[name=?]', 'locker_assignment[start_date(3i)]'
      assert_select 'select[name=?]', 'locker_assignment[expiration_date(1i)]'
      assert_select 'select[name=?]', 'locker_assignment[expiration_date(2i)]'
      assert_select 'select[name=?]', 'locker_assignment[expiration_date(3i)]'
      assert_select 'select[name=?]', 'locker_assignment[released_date(1i)]'
      assert_select 'select[name=?]', 'locker_assignment[released_date(2i)]'
      assert_select 'select[name=?]', 'locker_assignment[released_date(3i)]'
      assert_select 'input-select[name=?]', 'locker_assignment[locker_id]'
    end
  end
end
