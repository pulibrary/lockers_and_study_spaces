# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def locker_assignment_confirmation
    @locker_assignment = params[:locker_assignment]
    attachments['Locker Space Agreement.pdf'] = Rails.root.join('locker_agreement.pdf').read
    email = @locker_assignment.email
    mail(to: email,
         template_name: template_for_building(@locker_assignment&.locker&.building),
         from: @locker_assignment&.locker&.building&.email || 'access@princeton.edu',
         subject: 'Your Locker has been assigned')
  end

  def locker_violation
    @locker_violation = params[:locker_violation]
    attachments['Locker Space Agreement.pdf'] = Rails.root.join('locker_agreement.pdf').read

    email = @locker_violation.email
    mail(to: email, subject: 'Uncharged Materials in Locker')
  end

  def study_room_assignment_confirmation
    @study_room_assignment = params[:study_room_assignment]
    attachments['Study Room Agreement.pdf'] = Rails.root.join('study_room_agreement.pdf').read
    email = @study_room_assignment.email
    mail(to: email, subject: 'Your study room location has been assigned')
  end

  def study_room_violation
    @study_room_violation = params[:study_room_violation]
    attachments['Study Room Agreement.pdf'] = Rails.root.join('study_room_agreement.pdf').read

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

  private

  # Allow library-specific templates, by placing them at, for example,
  # app/views/user_mailer/lewis_locker_assignment_confirmation.html.erb
  def template_for_building(building)
    calling_method = caller_locations.first.label
    prefix = building&.name&.split&.first&.downcase
    template_name = "#{prefix}_#{calling_method}"
    return template_name if lookup_context.find_all(template_name, Array(self.class.mailer_name)).any?

    calling_method
  end
end
