# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec::Matchers.define :have_column_with_data do |column_name, expected_data|
  match do |row|
    return false unless row.is_a? CSV::Row

    row.find { |k, _v| k.strip == column_name }&.second&.strip == expected_data
  end
end

RSpec.describe LockerAssignmentsController do
  render_views
  let(:firestone) { FactoryBot.create(:building, name: 'Firestone Library') }
  let(:lewis) { FactoryBot.create(:building, name: 'Lewis Library') }
  let(:user) { FactoryBot.create(:user, :admin, building: firestone) }
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
        FactoryBot.create(:locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'junior',
                                                                                     department_at_application: department),
                          locker: FactoryBot.create(:locker, size: 6))
      end
      (start + 2).times do
        FactoryBot.create(:locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'staff',
                                                                                     department_at_application: department))
      end
      (start + 3).times do
        FactoryBot.create(:locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'senior',
                                                                                     department_at_application: department),
                          locker: FactoryBot.create(:locker, size: 6, floor: '3rd floor'))
      end
      (start + 4).times do
        FactoryBot.create(:locker_assignment,
                          locker_application: FactoryBot.create(:locker_application, status_at_application: 'faculty',
                                                                                     department_at_application: department),
                          locker: FactoryBot.create(:locker, floor: '3rd floor'))
      end
    end
    get :assignment_report, format: :csv
    expect(response.headers['Content-Disposition']).to start_with('attachment; filename="locker_assignment_report_')
    expect(response.body).to include('Department, Juniors, Seniors, Grad, Faculty, Staff')
    departments.each_with_index do |department, start|
      expect(response.body).to include("#{department}, #{start + 1}, #{start + 3}, 0, #{start + 4}, #{start + 2}")
    end

    # I do NOT wat to create all that data a second time, so I am adding the other report here
    StudyRoom.general_areas.each do |general_area|
      FactoryBot.create(:study_room_assignment, study_room: FactoryBot.create(:study_room, general_area:))
    end

    get :occupancy_report, format: :csv
    expect(response.headers['Content-Disposition']).to start_with('attachment; filename="locker_occupancy_report_')
    expect(response.body).to include('Space, Total Spaces, Total Spaces Assignable, Total Spaces Assigned, Total Spaces Available')
    expect(response.body).to include('Classics Graduate Study Room, 1, 1, 1, 0')
    expect(response.body).to include('History Graduate Study Room, 1, 1, 1, 0')
    expect(response.body).to include("4' 3rd floor, 225, 225, 225, 0")
    expect(response.body).to include("6' 3rd floor, 207, 207, 207, 0")
    expect(response.body).to include("4' 2nd floor, 189, 189, 189, 0")
    expect(response.body).to include("6' 2nd floor, 171, 171, 171, 0")
  end

  it 'does not include Lewis lockers in the occupancy report' do
    FactoryBot.create(:locker_assignment,
                      locker_application: FactoryBot.create(:locker_application, status_at_application: 'junior'),
                      locker: FactoryBot.create(:locker, size: 6, building: FactoryBot.create(:building, name: 'Firestone Library'), floor: '2nd floor'))
    FactoryBot.create(:locker_assignment,
                      locker_application: FactoryBot.create(:locker_application, status_at_application: 'junior'),
                      locker: FactoryBot.create(:locker, size: 2, building: FactoryBot.create(:building, name: 'Lewis Library'), floor: '3rd floor'))

    get :occupancy_report, format: :csv

    expect(response.body).to include("6' 2nd floor")
    expect(response.body).not_to include("2' 3rd floor")
  end

  it 'does not include Lewis lockers in the assignment report' do
    firestone = FactoryBot.create(:building, name: 'Firestone Library')
    lewis = FactoryBot.create(:building, name: 'Lewis Library')
    FactoryBot.create(:locker_assignment,
                      locker_application: FactoryBot.create(:locker_application, status_at_application: 'junior', department_at_application: 'Classics',
                                                                                 building: firestone),
                      locker: FactoryBot.create(:locker, size: 6, building: firestone, floor: '2nd floor'))
    FactoryBot.create(:locker_assignment,
                      locker_application: FactoryBot.create(:locker_application, status_at_application: 'senior', department_at_application: 'Biology',
                                                                                 building: lewis),
                      locker: FactoryBot.create(:locker, size: 2, building: lewis, floor: '3rd floor'))

    get :assignment_report, format: :csv
    csv = CSV.parse(response.body, headers: true)
    expect(csv.find { |row| row['Department'] == 'Classics' }).to have_column_with_data 'Juniors', '1'
    expect(csv.find { |row| row['Department'] == 'Biology' }).not_to have_column_with_data 'Seniors', '1'
  end

  context 'when admin is at the Lewis Library' do
    let(:building) { FactoryBot.create(:building, name: 'Lewis Library') }
    let(:user) { FactoryBot.create(:user, :admin, building:) }

    context 'when Lewis staff features are turned on' do
      before do
        allow(Flipflop).to receive(:lewis_staff?).and_return(true)
      end

      it 'can access the index screen' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when Lewis staff features are turned off' do
      before do
        allow(Flipflop).to receive(:lewis_staff?).and_return(false)
      end

      it 'cannot access the index screen' do
        get :index
        expect(response).to redirect_to('/')
        expect(flash[:alert]).to eq('Only administrators have access to Locker Assignments!')
      end
    end
  end

  describe '#index' do
    let(:firestone_application) { FactoryBot.create(:locker_application, building: firestone) }
    let(:firestone_assignment) { FactoryBot.create(:locker_assignment, locker_application: firestone_application) }
    let(:lewis_application) { FactoryBot.create(:locker_application, building: lewis) }
    let(:lewis_assignment) { FactoryBot.create(:locker_assignment, locker_application: lewis_application) }

    before do
      firestone_assignment
      lewis_assignment
    end

    context 'when Lewis admin views the index' do
      let(:user) { FactoryBot.create(:user, building: lewis) }

      it "only includes lockers for the admin's building" do
        controller.index
        expect(controller.instance_variable_get('@locker_assignments')).to include(lewis_assignment)
        expect(controller.instance_variable_get('@locker_assignments')).not_to include(firestone_assignment)
      end
    end

    context 'when Firestone admin views the index' do
      it "only includes lockers for the admin's building" do
        controller.index
        expect(controller.instance_variable_get('@locker_assignments')).to include(firestone_assignment)
        expect(controller.instance_variable_get('@locker_assignments')).not_to include(lewis_assignment)
      end
    end
  end
end
