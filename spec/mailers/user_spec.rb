# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#locker_assignment_confirmation' do
    let(:locker_assignment) { FactoryBot.create :locker_assignment }
    it 'sends an email to the assignee' do
      expect { described_class.with(locker_assignment: locker_assignment).locker_assignment_confirmation.deliver }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Your Locker has been assigned'
      expect(mail.to).to eq [locker_assignment.email]
      expect(mail.html_part.body.to_s).to have_content('Firestone Library Locker Assignment')
      expect(mail.html_part.body.to_s).to have_content(locker_assignment.name)
    end
  end

  describe '#locker_violation' do
    let(:locker_assignment) { FactoryBot.create :locker_assignment }
    it 'sends an email to the assignee' do
      locker_violation = LockerViolation.new(locker: locker_assignment.locker, user: locker_assignment.user, number_of_books: 8)
      expect { described_class.with(locker_violation: locker_violation).locker_violation.deliver }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Uncharged Materials in Locker'
      expect(mail.to).to eq [locker_violation.email]
      expect(mail.html_part.body.to_s).to have_content('Firestone Library Locker Violation')
      expect(mail.html_part.body.to_s).to have_content("Today 8 books were found in your locker #{locker_violation.location}"\
                                                       ' that were not checked out and we returned them to Circulation')
    end
  end
end
