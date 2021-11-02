# frozen_string_literal: true

require 'csv'

def row_attributes(row, klass)
  row.to_h.transform_keys(&:underscore).select { |k, _v| klass.new.attributes.keys.include?(k) }
end

def locker_size(type)
  if type.include?("4'")
    4
  else
    6
  end
end

def locker_attributes(row)
  attributes = row_attributes(row, Locker)
  attributes[:accessible] = row['AHA']
  attributes[:location] = row['space']
  attributes['size'] = locker_size(row['type'])
  attributes
end

def space_attributes(row, user, klass)
  attributes = row_attributes(row, klass)
  attributes[:start_date] = row['assignedDate']
  attributes[:released_date] = row['releaseDate']
  attributes[:notes] = [row['carrelMate'], row['Notes']].compact.join(', ')
  if user.provider == 'migration'
    attributes[:notes] = "Invalid user lookup for #{row['emailAddress']}, original_name: #{row['fistName']} #{row['lastName']}; #{attributes[:notes]}"
  end
  attributes
end

def locker_assignment_attributes(row, application, locker)
  attributes = space_attributes(row, application.user, LockerAssignment)
  attributes[:locker] = locker
  attributes[:locker_application] = application
  attributes
end

def study_room_assignment_attributes(row, user, study_room)
  attributes = space_attributes(row, user, StudyRoomAssignment)
  attributes[:study_room] = study_room
  attributes[:user] = user
  attributes
end

def locker_application_attributes(row, user)
  attributes = row_attributes(row, LockerApplication)
  attributes[:preferred_size] = locker_size(row['type'])
  attributes[:accessible] = row['handicapped']
  attributes[:user] = user
  attributes
end

CSV.parse(File.open(Rails.root.join('space_admins.csv'), encoding: 'ISO-8859-1'), headers: true) do |row|
  attributes = Ldap.find_by_netid(row['admin'])
  User.create(uid: row['admin'], admin: true, provider: 'cas') if attributes[:status] == 'staff'
end
Rails.logger.warn("Created #{User.count} Administrative Users")

CSV.parse(File.open(Rails.root.join('spaces.csv'), encoding: 'ISO-8859-1'), headers: true) do |row|
  if row['combination'].present? && row['combination'] != 'NULL'
    Locker.create(locker_attributes(row))
  elsif row['type'] == 'Study Room'
    StudyRoom.create(row_attributes(row, StudyRoom))
  else
    puts "Unknown type #{row['spaceID']}: #{row['type']}"
  end
end

Rails.logger.warn("Created #{Locker.count} Lockers and #{StudyRoom.count} Study Rooms")

CSV.parse(File.open(Rails.root.join('space_applicants.csv'), encoding: 'ISO-8859-1'), headers: true) do |row|
  user = User.from_email(row['emailAddress'])
  if %w[2 4].include?(row['spaceTypePreference'])
    application = LockerApplication.create(locker_application_attributes(row, user))
    if row['assignedDate'].present?
      locker = Locker.find_by(location: row['space'])
      LockerAssignment.create(locker_assignment_attributes(row, application, locker))
    end
  else
    study_room = StudyRoom.find_by(location: row['location'])
    StudyRoomAssignment.create(study_room_assignment_attributes(row, user, study_room))
  end
end

Rails.logger.warn("Created #{User.count} Users")
Rails.logger.warn("Created #{LockerApplication.count} Locker Applications and #{LockerAssignment.count} Locker Assignments")
Rails.logger.warn("Created #{StudyRoomAssignment.count} Study Rooms")
