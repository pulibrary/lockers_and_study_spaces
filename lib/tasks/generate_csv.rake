# frozen_string_literal: true

require 'csv'

# rubocop:disable Metrics/BlockLength
namespace :csv do
  desc 'Write database tables to CSV\'s'
  task all: :environment do
    Building.seed
    Rake::Task['csv:users'].invoke
    Rake::Task['csv:lockers'].invoke
    Rake::Task['csv:study_rooms'].invoke
    Rake::Task['csv:locker_applications'].invoke
    Rake::Task['csv:locker_assignments'].invoke
    Rake::Task['csv:study_room_assignments'].invoke
  end

  desc 'Write admin users to a csv'
  task admins: :environment do
    Building.seed
    headers = %w[id provider uid admin building_id]

    CSV.open('new_admins.csv', 'wb', write_headers: true, headers:) do |csv|
      User.where(admin: true).each do |admin|
        csv << CSV::Row.new(headers, headers.map { |header| admin.send(header) })
      end
    end
  end

  desc 'Write all users to a csv'
  task users: :environment do
    headers = %w[id provider uid admin building_id]
    write_db_to_csv(User, headers)
  end

  desc 'Write lockers to a csv'
  task lockers: :environment do
    headers = %w[id location size general_area accessible notes combination code tag
                 discs clutch hubpos key_number floor disabled building_id]
    write_db_to_csv(Locker, headers)
  end

  desc 'Write study rooms to a csv'
  task study_rooms: :environment do
    headers = %w[id location general_area notes]
    write_db_to_csv(StudyRoom, headers)
  end

  desc 'Write locker applications to a csv'
  task locker_applications: :environment do
    headers = %w[id preferred_size preferred_general_area accessible semester status_at_application
                 department_at_application user_id created_at archived building_id
                 complete accessibility_needs]
    CSV.open('new_locker_applications.csv', 'wb', write_headers: true, headers:) do |csv|
      LockerApplication.find_each do |obj|
        values = headers.map do |header|
          val = obj.send(header)
          if val.instance_of?(Array)
            val.join(' | ') unless val.empty?
          else
            val
          end
        end

        csv << CSV::Row.new(headers, values)
      end
    end
  end

  desc 'Write locker assignments to a csv'
  task locker_assignments: :environment do
    headers = %w[id start_date expiration_date released_date notes locker_application_id
                 locker_id created_at]
    write_db_to_csv(LockerAssignment, headers)
  end

  desc 'Write study room assignments to a csv'
  task study_room_assignments: :environment do
    headers = %w[id start_date expiration_date released_date notes user_id study_room_id created_at]
    write_db_to_csv(StudyRoomAssignment, headers)
  end
end
# rubocop:enable Metrics/BlockLength

def write_db_to_csv(klass, headers)
  collection = klass.model_name.collection
  CSV.open("new_#{collection}.csv", 'wb', write_headers: true, headers:) do |csv|
    klass.find_each do |obj|
      csv << CSV::Row.new(headers, headers.map { |header| obj.send(header) })
    end
  end
end
