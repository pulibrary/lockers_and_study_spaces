# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/new', type: :view do
  before(:each) do
    assign(:locker_assignment, LockerAssignment.new(
                                 locker_application: nil,
                                 locker: nil
                               ))
  end

  it 'renders new locker_assignment form' do
    render

    assert_select 'form[action=?][method=?]', locker_assignments_path, 'post' do
      assert_select 'input[name=?]', 'locker_assignment[locker_application]'

      assert_select 'input[name=?]', 'locker_assignment[locker_id]'
    end
  end
end
