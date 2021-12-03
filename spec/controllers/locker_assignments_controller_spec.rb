# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerAssignmentsController do
  render_views
  let(:user) { FactoryBot.create :user, :admin }
  let(:departments) { LockerApplication.new.department_list }

  before do
    sign_in user
  end

  it 'downloads a csv with locker Assignment by department and status' do
    departments.each_with_index do |department, start|
      (start + 1).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'junior',
                                                                                     department_at_application: department)
      end
      (start + 2).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'staff',
                                                                                     department_at_application: department)
      end
      (start + 3).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'senior',
                                                                                     department_at_application: department)
      end
      (start + 4).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'faculty',
                                                                                     department_at_application: department)
      end
    end
    get :assignment_report, format: :csv
    expect(response.headers['Content-Disposition']).to start_with("attachment\; filename=\"locker_assigment_report_")
    expect(response.body).to include('Department, Junoirs, Seniors, Grad, Faculty, Staff')
    departments.each_with_index do |department, start|
      expect(response.body).to include("#{department}, #{start + 1}, #{start + 3}, 0, #{start + 4}, #{start + 2}")
    end
  end
end
