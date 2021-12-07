# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerAssignmentsController do
  render_views
  let(:user) { FactoryBot.create :user, :admin }
  let(:departments) do
    ['African American Studies', 'Anthropology', 'Classics', 'Comparative Literature', 'Economics', 'English',
     'French and Italian', 'Germanic Languages and Literatures', 'History', 'Near Eastern Studies', 'Other',
     'Philosophy', 'Politics', 'Religion', 'School of Public and International Affairs', 'Slavic Languages and Literatures',
     'Sociology', 'Spanish and Portuguese']
  end
  let(:size_floor_list) { Locker.new.size_floor_list }

  before do
    sign_in user
  end

  it 'downloads a csv with locker Assignment by department and occupancy report' do
    departments.each_with_index do |department, start|
      (start + 1).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'junior',
                                                                                     department_at_application: department),
                          locker: FactoryBot.create(:locker, size: 6)
      end
      (start + 2).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'staff',
                                                                                     department_at_application: department)
      end
      (start + 3).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'senior',
                                                                                     department_at_application: department),
                          locker: FactoryBot.create(:locker, size: 6, floor: '3rd floor')
      end
      (start + 4).times do
        FactoryBot.create :locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'faculty',
                                                                                     department_at_application: department),
                          locker: FactoryBot.create(:locker, floor: '3rd floor')
      end
    end
    get :assignment_report, format: :csv
    expect(response.headers['Content-Disposition']).to start_with("attachment\; filename=\"locker_assignment_report_")
    expect(response.body).to include('Department, Juniors, Seniors, Grad, Faculty, Staff')
    departments.each_with_index do |department, start|
      expect(response.body).to include("#{department}, #{start + 1}, #{start + 3}, 0, #{start + 4}, #{start + 2}")
    end

    # I do NOT wat to create all that data a second time, so I am adding the other report here
    StudyRoom.general_areas.each do |general_area|
      FactoryBot.create(:study_room_assignment, study_room: FactoryBot.create(:study_room, general_area: general_area))
    end

    get :occupancy_report, format: :csv
    expect(response.headers['Content-Disposition']).to start_with("attachment\; filename=\"locker_occupancy_report_")
    expect(response.body).to include('Space, Total Spaces, Total Spaces Assignable, Total Spaces Assigned, Total Spaces Available')
    expect(response.body).to include('Classics Graduate Study Room, 1, 1, 1, 0')
    expect(response.body).to include('History Graduate Study Room, 1, 1, 1, 0')
    expect(response.body).to include("4' 3rd floor, 225, 225, 225, 0")
    expect(response.body).to include("6' 3rd floor, 207, 207, 207, 0")
    expect(response.body).to include("4' 2nd floor, 189, 189, 189, 0")
    expect(response.body).to include("6' 2nd floor, 171, 171, 171, 0")
  end
end
