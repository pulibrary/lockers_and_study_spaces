# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/edit', type: :view do
  let(:locker) { FactoryBot.create :locker }
  let(:locker_application) { FactoryBot.create :locker_application }
  before(:each) do
    @locker_assignment = assign(:locker_assignment, LockerAssignment.create!(
                                                      locker_application: locker_application,
                                                      locker: locker
                                                    ))
  end

  it 'renders the edit locker_assignment form' do
    render

    assert_select 'form[action=?][method=?]', locker_assignment_path(@locker_assignment), 'post' do
      assert_select 'input[name=?]', 'locker_assignment[locker_application]'

      assert_select 'input[name=?]', 'locker_assignment[locker_id]'
    end
  end
end
