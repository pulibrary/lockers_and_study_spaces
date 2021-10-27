# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/show', type: :view do
  let(:locker) { FactoryBot.create :locker }
  let(:locker_application) { FactoryBot.create :locker_application }
  before(:each) do
    @locker_assignment = assign(:locker_assignment, LockerAssignment.create!(
                                                      locker_application: locker_application,
                                                      locker: locker,
                                                      start_date: DateTime.current.to_date
                                                    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/#{locker.location}/)
    expect(rendered).to match(/#{locker_application.applicant}/)
  end
end
