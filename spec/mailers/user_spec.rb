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
end
