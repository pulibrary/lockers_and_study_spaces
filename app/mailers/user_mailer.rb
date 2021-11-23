# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def locker_assignment_confirmation
    @locker_assignment = params[:locker_assignment]

    email = @locker_assignment.email
    mail(to: email, subject: 'Your Locker has been assigned')
  end
end
