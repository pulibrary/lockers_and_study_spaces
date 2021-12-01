# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def locker_assignment_confirmation
    @locker_assignment = params[:locker_assignment]
    attachments['Locker Space Agreement.pdf'] = File.read(Rails.root.join('locker_agreement.pdf'))
    email = @locker_assignment.email
    mail(to: email, subject: 'Your Locker has been assigned')
  end

  def locker_violation
    @locker_violation = params[:locker_violation]

    email = @locker_violation.email
    mail(to: email, subject: 'Uncharged Materials in Locker')
  end
end