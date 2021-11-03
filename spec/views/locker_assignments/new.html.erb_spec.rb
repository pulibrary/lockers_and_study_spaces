# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/new', type: :view do
  before(:each) do
    assign(:locker_assignment, LockerAssignment.new(
                                 locker_application: nil,
                                 locker: nil,
                                 start_date: DateTime.current.to_date
                               ))
  end

  it 'renders new locker_assignment form' do
    render
    assert_select 'form[action=?][method=?]', locker_assignments_path, 'post' do
      assert_select 'date-picker[name=?]', 'locker_assignment[start_date]'
      assert_select 'date-picker[name=?]', 'locker_assignment[expiration_date]'
      assert_select 'date-picker[name=?]', 'locker_assignment[released_date]'
      assert_select 'input-select[name=?]', 'locker_assignment[locker_id]'
    end
  end
end
