# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/edit', type: :view do
  let(:locker) { FactoryBot.create :locker }
  let(:locker_application) { FactoryBot.create :locker_application }
  before(:each) do
    @locker_assignment = assign(:locker_assignment, LockerAssignment.create!(
                                                      locker_application: locker_application,
                                                      locker: locker,
                                                      start_date: DateTime.current.to_date
                                                    ))
  end

  it 'renders the edit locker_assignment form' do
    render
    expect(rendered).to match(/#{locker_application.preferred_size}/)
    expect(rendered).to match(/#{locker_application.preferred_general_area}/)
    expect(rendered).to match(/#{locker_application.applicant}/)
    assert_select 'form[action=?][method=?]', locker_assignment_path(@locker_assignment), 'post' do
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