# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledMessage do
  let(:firestone) { FactoryBot.create(:building, id: 1) }
  let(:lewis) { FactoryBot.create(:building, name: 'Lewis Library', id: 2) }

  describe 'scopes' do
    let(:yesterday) { described_class.create!(schedule: Date.yesterday, building_id: firestone.id) }
    let(:today) { described_class.create!(schedule: Date.today, building_id: firestone.id) }
    let(:tomorrow) { described_class.create!(schedule: Date.tomorrow, building_id: firestone.id) }

    describe '.past' do
      it 'includes messages scheduled for yesterday' do
        expect(described_class.past).to include(yesterday)
      end

      it 'does not include messages for today or later' do
        expect(described_class.past).not_to include(today)
        expect(described_class.past).not_to include(tomorrow)
      end
    end

    describe '.today' do
      it 'includes messages scheduled for today' do
        expect(described_class.today).to include(today)
      end

      it 'does not include messages for past or future days' do
        expect(described_class.today).not_to include(yesterday)
        expect(described_class.today).not_to include(tomorrow)
      end
    end

    describe '.future' do
      it 'includes messages scheduled for tomorrow' do
        expect(described_class.future).to include(tomorrow)
      end

      it 'does not include messages for today or earlier' do
        expect(described_class.future).not_to include(yesterday)
        expect(described_class.future).not_to include(today)
      end
    end
  end

  describe '#daterange_string_to_daterange' do
    it 'converts a daterange string to a daterange' do
      string_from_lux = '5/19/2022 - 5/24/2022'
      expected = Date.new(2022, 5, 19)..Date.new(2022, 5, 24)
      expect(described_class.new.daterange_string_to_daterange(string_from_lux)).to eq(expected)
    end
  end

  describe '#send_emails' do
    let!(:message_to_send) do
      described_class.create(schedule: Date.today,
                             type: 'LockerRenewalMessage',
                             user_filter: 'not_a_senior_or_faculty',
                             template: 'firestone_locker_renewal',
                             applicable_range: Date.today..2.years.from_now,
                             building_id: firestone.id)
    end
    let!(:assignment) { FactoryBot.create(:locker_assignment) }

    it 'sends Firestone messages for today' do
      FactoryBot.create_list(:locker_assignment, 2)
      expect { message_to_send.send_emails }
        .to change { ActionMailer::Base.deliveries.count }.by(3)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Locker Renewal'
      expect(mail.text_part.body).to include 'April Miller'
      expect(message_to_send.reload.results['success'].count).to eq(3)
    end

    context 'there is evidence the message has been sent' do
      let!(:message_to_send) do
        described_class.new(schedule: Date.today,
                            results: { success: ['netid@princeton.edu'] })
      end

      it 'does not send scheduled messages' do
        expect { message_to_send.send_emails }
          .not_to(change { ActionMailer::Base.deliveries.count })
      end
    end

    context 'the message is scheduled for tomorrow' do
      let!(:message_to_send) do
        described_class.create(schedule: Date.tomorrow,
                               type: 'LockerRenewalMessage',
                               user_filter: 'not_a_senior_or_faculty',
                               template: 'locker_renewal',
                               applicable_range: Date.today..2.years.from_now,
                               building_id: firestone.id)
      end

      it 'does not send scheduled messages' do
        expect { message_to_send.send_emails }
          .not_to(change { ActionMailer::Base.deliveries.count })
      end
    end

    context 'for Lewis locker patrons' do
      let!(:message_to_send) do
        described_class.create(schedule: Date.today,
                               type: 'LockerRenewalMessage',
                               user_filter: 'not_a_senior_or_faculty',
                               template: 'lewis_locker_renewal',
                               applicable_range: Date.today..2.years.from_now,
                               building_id: lewis.id)
      end
      let!(:locker1) { FactoryBot.create(:locker, building_id: 2) }
      let!(:locker2) { FactoryBot.create(:locker, building_id: 2) }
      let!(:locker3) { FactoryBot.create(:locker, building_id: 1) }
      let!(:assignment1) { FactoryBot.create(:locker_assignment, locker: locker1) }
      let!(:assignment2) { FactoryBot.create(:locker_assignment, locker: locker2) }
      let!(:assignment3) { FactoryBot.create(:locker_assignment, locker: locker3) }

      it 'sends only Lewis messages for today' do
        expect { message_to_send.send_emails }
          .to change { ActionMailer::Base.deliveries.count }.by(2)
        mail = ActionMailer::Base.deliveries.last
        expect(mail.subject).to eq 'Locker Renewal'
        expect(mail.text_part.body).to include 'Sylvia Swain'
        expect(message_to_send.reload.results['success'].count).to eq(2)
      end
    end

    context 'when email has two @ symbols' do
      let!(:user) { FactoryBot.create(:user, uid: 'uid384y96767632y@') }
      let!(:app) { FactoryBot.create(:locker_application, user:) }
      let!(:assignment) { FactoryBot.create(:locker_assignment, locker_application: app) }

      it 'sends messages after correcting the email' do
        message_to_send.send_emails
        mail = ActionMailer::Base.deliveries.last
        expect(mail.bcc).to contain_exactly('uid384y96767632y@princeton.edu')
      end
    end
  end
end
