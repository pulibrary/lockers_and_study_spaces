# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def locker_assignment_confirmation
    user = User.new
    application = LockerApplication.new(user: user,
                                        applicant: Applicant.new(user,
                                                                 ldap: { email: 'sally.smith@example.com', name: 'Sally Smith', pustatus: 'stf',
                                                                         status: 'staff', department: 'History' }))
    locker_assignment = LockerAssignment.new(locker_application: application, locker: Locker.new(location: '2-9-G-2'),
                                             expiration_date: DateTime.now.to_date)
    UserMailer.with(locker_assignment: locker_assignment).locker_assignment_confirmation
  end
end
