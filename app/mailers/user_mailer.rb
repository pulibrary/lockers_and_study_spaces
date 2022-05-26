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
    attachments['Locker Space Agreement.pdf'] = File.read(Rails.root.join('locker_agreement.pdf'))

    email = @locker_violation.email
    mail(to: email, subject: 'Uncharged Materials in Locker')
  end

  def study_room_assignment_confirmation
    @study_room_assignment = params[:study_room_assignment]
    attachments['Study Room Agreement.pdf'] = File.read(Rails.root.join('study_room_agreement.pdf'))
    email = @study_room_assignment.email
    mail(to: email, subject: 'Your study room location has been assigned')
  end

  def study_room_violation
    @study_room_violation = params[:study_room_violation]
    attachments['Study Room Agreement.pdf'] = File.read(Rails.root.join('study_room_agreement.pdf'))

    email = @study_room_violation.email
    mail(to: email, subject: 'Uncharged Materials in Study Room')
  end

  def renewal_email
    @assignment = params[:assignment]
    mail(
      bcc: @assignment.email,
      subject: 'Locker Renewal',
      template_name: params[:template_name]
    )
  end

  def scheduled_messages
    ScheduledMessage.today.not_yet_sent.each do |message|
      assignments = relevant_assignments(message)
      assignments.each do |assignment|
        @assignment = assignment
        mail(
          bcc: assignment.email,
          subject: 'Locker Renewal',
          template_name: message.template
        )
      end
      message.results = { success: assignments.map(&:email) }
      message.save!
    end
  end
end
