# frozen_string_literal: true

require 'csv'

Building.seed

# File was generated using csv:users rake task
CSV.parse(File.open(Rails.root.join('new_users.csv')), headers: true) do |row|
  User.find_or_create_by(row.to_hash)
end
Rails.logger.warn("Created #{User.count} Users")
Rails.logger.warn("Created #{User.where(admin: true).count} Administrative Users")

# File was generated using the csv:lockers rake task
CSV.parse(File.open(Rails.root.join('new_lockers.csv')), headers: true) do |row|
  Locker.find_or_create_by(row.to_hash)
end
Rails.logger.warn("Created #{Locker.count} Lockers")

# File was generated using the csv:study_rooms rake task
CSV.parse(File.open(Rails.root.join('new_study_rooms.csv')), headers: true) do |row|
  StudyRoom.find_or_create_by(row.to_hash)
end
Rails.logger.warn("Created #{StudyRoom.count} Study Rooms")

# File was generated using the csv:locker_applications rake task
CSV.parse(File.open(Rails.root.join('new_locker_applications.csv')), headers: true) do |row|
  row_hash = row.to_hash
  created_at = row_hash.delete('created_at')
  row_hash['accessibility_needs'] = if row_hash['accessibility_needs']
                                      row_hash['accessibility_needs'].split(' | ')
                                    else
                                      []
                                    end
  app = LockerApplication.find_or_create_by(row_hash)
  app.update(created_at:) if app.new_record?
end
Rails.logger.warn("Created #{LockerApplication.count} Locker Applications")

# File was generated using the csv:locker_assignments rake task
CSV.parse(File.open(Rails.root.join('new_locker_assignments.csv')), headers: true) do |row|
  row_hash = row.to_hash
  created_at = row_hash.delete('created_at')
  assignment = LockerAssignment.find_or_create_by(row_hash)
  assignment.update(created_at:) if assignment.new_record?
end
Rails.logger.warn("Created #{LockerAssignment.count} Locker Assignments")

# File was generated using the csv:study_room_assignments rake task
CSV.parse(File.open(Rails.root.join('new_study_room_assignments.csv')), headers: true) do |row|
  row_hash = row.to_hash
  created_at = row_hash.delete('created_at')
  assignment = StudyRoomAssignment.find_or_create_by(row_hash)
  assignment.update(created_at:) if assignment.new_record?
end
Rails.logger.warn("Created #{StudyRoomAssignment.count} Study Room Assignments")
