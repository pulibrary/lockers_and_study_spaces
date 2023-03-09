# frozen_string_literal: true

firestone = Building.find_or_create_by(name: 'Firestone Library')
firestone.email = 'access@princeton.edu'
firestone.save
lewis = Building.find_or_create_by(name: 'Lewis Library')
lewis.email = 'lewislib@princeton.edu'
Rails.logger.warn("Created #{Building.count} Buildings")

# Turn Lewis features on
Rake::Task['flipflop:turn_on'].execute(feature: 'lewis_staff', strategy: 'active_record')
Rake::Task['flipflop:turn_on'].execute(feature: 'lewis_patrons', strategy: 'active_record')
Rails.logger.warn('Turned on Lewis features')

# Create admin users
team_uids = %w[mk8066 kr2 rl8282 cc62 heberlei js7389]
team_uids.each do |uid|
  user = User.find_or_create_by!(
    uid:,
    admin: true
  )
  # everyone is a firestone admin
  # user.building = firestone
  # everyone is a lewis admin
  user.building = lewis
  # everyone is randomly assigned as either a Firestone or Lewis admin
  #  user.building = rand(1..2) == 1 ? firestone : lewis
  user.save
end
Rails.logger.warn("Created #{User.where(admin: true).count} Administrative Users")

# Create regular users
# Random uids created using Faker::Alphanumeric.unique.alphanumeric(number: 6)
# Create Firestone users
random_uids_firestone = %w[11d6ub hesg5n i8zt70 uvhep6 e1qext]
random_uids_firestone.each do |uid|
  User.find_or_create_by!(
    uid:,
    building: firestone
  )
end
# Create Lewis users
# Random uids created using Faker::Alphanumeric.unique.alphanumeric(number: 6)
random_uids_lewis = %w[j9qnnr g5tk6j wecdks 8x90nm pz52f5]
random_uids_lewis.each do |uid|
  User.find_or_create_by!(
    uid:,
    building: lewis
  )
end
Rails.logger.warn("Created 10 Users, total user count: #{User.count}")

# Create Lockers
# Create Firestone Lockers
Rake::Task['lockers:firestone:fake'].invoke
Rails.logger.warn("Created #{Locker.where(building: firestone).count} Firestone Lockers")
# Create Lewis Lockers
Rake::Task['lockers:lewis:seed'].invoke
Rails.logger.warn("Created #{Locker.where(building: lewis).count} Lewis Lockers")

# Create study rooms
Rake::Task['study_spaces:fake'].invoke
Rails.logger.warn("Created #{StudyRoom.count} Study Rooms")

# Create Locker Applications
# Create Firestone Locker Applications
firestone_applications = [
  {
    preferred_size: 4,
    preferred_general_area: '2nd floor',
    accessible: false,
    semester: 'Fall',
    status_at_application: 'junior',
    department_at_application: 'Something science-y',
    user_id: User.find_by(uid: random_uids_firestone[0]).id,
    building: firestone,
    complete: true,
    accessibility_needs: []
  },
  # archived duplicate
  {
    preferred_size: 4,
    preferred_general_area: '2nd floor',
    accessible: false,
    semester: 'Fall',
    status_at_application: 'junior',
    department_at_application: 'Something science-y',
    user_id: User.find_by(uid: random_uids_firestone[0]).id,
    archived: true,
    building: firestone,
    complete: true,
    accessibility_needs: []
  },
  {
    preferred_size: 4,
    preferred_general_area: 'C floor',
    accessible: false,
    semester: 'Spring',
    status_at_application: 'staff',
    department_at_application: 'Something library-y',
    user_id: User.find_by(uid: random_uids_firestone[1]).id,
    building: firestone,
    complete: true,
    accessibility_needs: ['Near an elevator']
  },
  # intentional duplicate
  {
    preferred_size: 6,
    preferred_general_area: 'C floor',
    accessible: false,
    semester: 'Spring',
    status_at_application: 'staff',
    department_at_application: 'Something library-y',
    user_id: User.find_by(uid: random_uids_firestone[1]).id,
    building: firestone,
    complete: true,
    accessibility_needs: ['Near an elevator']
  }
]
firestone_applications.each do |app|
  LockerApplication.find_or_create_by!(app)
end

# Create Lewis Locker Applications
lewis_applications = [
  {
    preferred_size: 2,
    preferred_general_area: '3rd floor',
    accessible: false,
    semester: 'Fall',
    status_at_application: 'junior',
    department_at_application: 'Something science-y',
    user_id: User.find_by(uid: random_uids_lewis[0]).id,
    building: lewis,
    complete: true,
    accessibility_needs: []
  },
  # archived duplicate
  {
    preferred_size: 2,
    preferred_general_area: '3rd floor',
    accessible: false,
    semester: 'Fall',
    status_at_application: 'junior',
    department_at_application: 'Something science-y',
    user_id: User.find_by(uid: random_uids_lewis[0]).id,
    archived: true,
    building: lewis,
    complete: true,
    accessibility_needs: []
  },
  {
    preferred_size: 2,
    preferred_general_area: '4th floor',
    accessible: false,
    semester: 'Spring',
    status_at_application: 'staff',
    department_at_application: 'Something library-y',
    user_id: User.find_by(uid: random_uids_lewis[1]).id,
    building: lewis,
    complete: true,
    accessibility_needs: ['Near an elevator']
  },
  # intentional duplicate
  {
    preferred_size: 2,
    preferred_general_area: '3rd floor',
    accessible: false,
    semester: 'Spring',
    status_at_application: 'staff',
    department_at_application: 'Something library-y',
    user_id: User.find_by(uid: random_uids_lewis[1]).id,
    building: lewis,
    complete: true,
    accessibility_needs: ['Near an elevator']
  },
  # Firestone duplicate
  {
    preferred_size: 2,
    preferred_general_area: '3rd floor',
    accessible: false,
    semester: 'Fall',
    status_at_application: 'junior',
    department_at_application: 'Something science-y',
    user_id: User.find_by(uid: random_uids_firestone[0]).id,
    building: lewis,
    complete: true,
    accessibility_needs: []
  }
]
lewis_applications.each do |app|
  LockerApplication.find_or_create_by!(app)
end
Rails.logger.warn("Created #{LockerApplication.count} Locker Applications")

# Create Locker Assignments
start_date = Date.new(2023, 3, 3)
expiration_date = Date.new(2024, 3, 3)
# Firestone Locker Assignments
firestone_app_to_assign = LockerApplication.find_by(firestone_applications.first)
firestone_locker = Locker.where(building: firestone, floor: '2nd floor').first
LockerAssignment.find_or_create_by!(locker_application: firestone_app_to_assign, start_date:, expiration_date:, locker: firestone_locker)

# Lewis Locker Assignments
lewis_app_to_assign = LockerApplication.find_by(lewis_applications.first)
lewis_locker = Locker.where(building: lewis, floor: '3rd floor').first
LockerAssignment.find_or_create_by!(locker_application: lewis_app_to_assign, start_date:, expiration_date:, locker: lewis_locker)

Rails.logger.warn("Created #{LockerAssignment.count} Locker Assignments")

# Create Study Room Assignments
study_room = StudyRoom.first
StudyRoomAssignment.find_or_create_by!(study_room:, start_date:, expiration_date:, user_id: User.find_by(uid: random_uids_firestone[2]).id)

Rails.logger.warn("Created #{StudyRoomAssignment.count} Study Room Assignments")
