# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def locker_assignment_confirmation
    user = User.new
    application = LockerApplication.new(user: user,
                                        applicant: Applicant.new(user,
                                                                 ldap: { email: 'sally.smith@example.com', name: 'Sally Smith', pustatus: 'stf',
                                                                         status: 'staff', department: 'History' }))
    locker_assignment = LockerAssignment.new(locker_application: application, locker: Locker.new(location: '2-9-G-2', combination: '11-22-33'),
                                             expiration_date: DateTime.now.to_date)
    UserMailer.with(locker_assignment: locker_assignment).locker_assignment_confirmation
  end

  # rubocop:disable Metrics/AbcSize
  # not worried about the code to set up a preview being a bit too messy
  def locker_violation
    user = User.find_by(uid: 'abc123')
    user ||= User.create(uid: 'abc123')
    locker = Locker.find_by(location: '2-9-G-2')
    if locker.nil?
      locker = Locker.create(location: '2-9-G-2', general_area: 'General Area', combination: 'combination')
      application = LockerApplication.create(user: user,
                                             applicant: Applicant.new(user,
                                                                      ldap: { email: 'sally.smith@example.com', name: 'Sally Smith', pustatus: 'stf',
                                                                              status: 'staff', department: 'History' }))
      LockerAssignment.create(locker_application: application, locker: locker,
                              expiration_date: DateTime.tomorrow.to_date, start_date: DateTime.now.to_date)
    end
    LockerViolation.where(locker: locker).destroy_all
    locker_violation = LockerViolation.create(locker: locker, user: user)
    UserMailer.with(locker_violation: locker_violation).locker_violation
  end
  # rubocop:enable Metrics/AbcSize
end
