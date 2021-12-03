# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
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
  attributes[:general_area] = row['location']
  attributes[:floor] = row['floor_str']
  attributes['size'] = locker_size(row['type'])
  attributes[:disabled] = row['maxOccupancy'] == '0'
  attributes
end

def study_room_attributes(row)
  attributes = row_attributes(row, StudyRoom)
  attributes[:general_area] = row['floor_str']
  attributes
end

def space_attributes(row, user, klass)
  attributes = row_attributes(row, klass)
  attributes[:start_date] = row['assignedDate']
  attributes[:released_date] = row['releaseDate']
  attributes[:notes] = [row['carrelMate'], row['Notes']].compact.join(', ')
  attributes[:created_at] = row['assignedDate']
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
  attributes['status_at_application'] = attributes['status_at_application'].downcase
  attributes['status_at_application'] = 'graduate' if attributes['status_at_application'] == 'grad student'
  attributes[:preferred_size] = locker_size(row['type'])
  attributes[:accessible] = row['handicapped']
  attributes[:created_at] = row['date_of_application']
  attributes[:user] = user
  attributes
end

def setup_study_room(row, user)
  study_room = StudyRoom.find_by(location: row['location'])
  if study_room.blank?
    puts "Blank location: #{row['location']}"
  else
    StudyRoomAssignment.create(study_room_assignment_attributes(row, user, study_room))
  end
end

def lookup_locker(row)
  locker = Locker.find_by(location: row['space'])
  locker ||= Locker.find_by(location: row['location'])

  # defunct location, lets assume it was a locker they wanted...
  if row['location'] == 'NULL' && (row['spaceAssigned'] != 'NULL')
    locker = Locker.find_by(location: 'DEFUNCT')
    locker ||= Locker.create!(location: 'DEFUNCT', combination: 'DEFUNCT', general_area: 'DEFUNCT')
  end
  locker
end

def setup_locker(row, user)
  locker = lookup_locker(row)
  if locker.present?
    application = LockerApplication.create(locker_application_attributes(row, user))
    LockerAssignment.create(locker_assignment_attributes(row, application, locker)) if row['assignedDate'].present?
  elsif row['location'] == 'NULL'
    LockerApplication.create(locker_application_attributes(row, user))
  else
    setup_study_room(row, user)
  end
end

# file was generate using `SELECT TOP * FROM [Admins]` query
CSV.parse(File.open(Rails.root.join('space_admins.csv'), encoding: 'ISO-8859-1'), headers: true) do |row|
  attributes = Ldap.find_by_netid(row['admin'])
  User.create(uid: row['admin'], admin: true, provider: 'cas') if attributes[:status] == 'staff'
end
Rails.logger.warn("Created #{User.count} Administrative Users")

# file was generated using the following sql from the old application
# ```
# SELECT Spaces.*, Location.location as floor_str, SpaceType.type
#    FROM [Spaces] join SpaceType on Spaces.spaceType = SpaceType.id join location on Spaces.floor = Location.id
# ```
CSV.parse(File.open(Rails.root.join('spaces.csv'), encoding: 'ISO-8859-1'), headers: true) do |row|
  if row['combination'].present? && row['combination'] != 'NULL'
    Locker.create(locker_attributes(row))
  elsif row['type'] == 'Study Room'
    StudyRoom.create(study_room_attributes(row))
  else
    puts "Unknown type #{row['spaceID']}: #{row['type']}"
  end
end

Rails.logger.warn("Created #{Locker.count} Lockers and #{StudyRoom.count} Study Rooms")

# File was generated using the following sql from the old application
# ```
# SELECT Applicant.*, Status.status as statusAtApplication, Location.location as preferredGeneralArea, Department.deptTitle as departmentAtApplication,
#    Semester.semester, Spaces.space, Spaces.location, SpaceType.type FROM [Applicant]
# join Status on Applicant.status = Status.id
# join Location on Applicant.locationPreference = Location.id
# join Department on Applicant.deptID = Department.deptId
# join Semester on Applicant.occupancySemester = Semester.id
# left join Spaces on Applicant.spaceAssigned = Spaces.spaceId
# join SpaceType on Applicant.spaceTypePreference = SpaceType.id
# where date_of_application > '20190101' or (releaseDate is null and assignedDate is not null and expirationDate > CURRENT_TIMESTAMP)
# ```
CSV.parse(File.open(Rails.root.join('space_applicants.csv'), encoding: 'ISO-8859-1'), headers: true) do |row|
  user = User.from_email(row['emailAddress'])
  if %w[2 4].include?(row['spaceTypePreference'])
    setup_locker(row, user)
  else
    setup_study_room(row, user)
  end
end

Rails.logger.warn("Created #{User.count} Users")
Rails.logger.warn("Created #{LockerApplication.count} Locker Applications and #{LockerAssignment.count} Locker Assignments")
Rails.logger.warn("Created #{StudyRoomAssignment.count} Study Rooms")
# rubocop:enable Metrics/AbcSize
