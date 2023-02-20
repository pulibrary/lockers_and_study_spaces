# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer do
  describe '#locker_assignment_confirmation' do
    let(:locker_assignment) { FactoryBot.create(:locker_assignment) }

    it 'sends an email to the assignee' do
      expect { described_class.with(locker_assignment:).locker_assignment_confirmation.deliver }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Your Locker has been assigned'
      expect(mail.to).to eq [locker_assignment.email]
      expect(mail.from).to eq ['access@princeton.edu']
      expect(mail.html_part.body.to_s).to have_content('Firestone Library Locker Assignment')
      expect(mail.html_part.body.to_s).to have_content(locker_assignment.name)
      expect(mail.html_part.body.to_s).to have_content(locker_assignment.combination)
      expect(mail.html_part.body.to_s).to have_content('To Unlock')
      expect(mail.html_part.body.to_s).to have_content('To Lock')
      expect(mail.attachments.first.content_type).to eq('application/pdf; filename="Locker Space Agreement.pdf"')
    end

    context 'when assignment is for a Lewis Locker' do
      let(:locker_assignment) do
        building = FactoryBot.create(:building, email: 'lewislib@princeton.edu', name: 'Lewis Library')
        lewis_locker = FactoryBot.create(:locker, building:)
        FactoryBot.create(:locker_assignment,
                          locker: lewis_locker)
      end

      it 'comes from the lewis email address' do
        expect { described_class.with(locker_assignment:).locker_assignment_confirmation.deliver }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
        mail = ActionMailer::Base.deliveries.last
        expect(mail.from).to eq ['lewislib@princeton.edu']
      end

      it 'includes Lewis text' do
        expect { described_class.with(locker_assignment:).locker_assignment_confirmation.deliver }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
        mail = ActionMailer::Base.deliveries.last
        expect(mail.html_part.body.to_s).to have_content('Lewis Library Locker Assignment')
      end
    end
  end

  describe '#locker_violation' do
    let(:locker_assignment) { FactoryBot.create(:locker_assignment) }

    it 'sends an email to the assignee' do
      locker_violation = LockerViolation.new(locker: locker_assignment.locker, user: locker_assignment.user, number_of_books: 8)
      expect { described_class.with(locker_violation:).locker_violation.deliver }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Uncharged Materials in Locker'
      expect(mail.to).to eq [locker_violation.email]
      expect(mail.from).to eq ['access@princeton.edu']
      expect(mail.html_part.body.to_s).to have_content('Firestone Library Locker Violation')
      expect(mail.html_part.body.to_s).to have_content("Today 8 books were found in your locker #{locker_violation.location} " \
                                                       'that were not checked out and we returned them to Circulation')
      expect(mail.attachments.first.content_type).to eq('application/pdf; filename="Locker Space Agreement.pdf"')
    end
  end

  describe '#study_room_assignment_confirmation' do
    let(:study_room_assignment) { FactoryBot.create(:study_room_assignment) }

    it 'sends an email to the assignee' do
      expect { described_class.with(study_room_assignment:).study_room_assignment_confirmation.deliver }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Your study room location has been assigned'
      expect(mail.to).to eq [study_room_assignment.email]
      expect(mail.from).to eq ['access@princeton.edu']
      expect(mail.html_part.body.to_s).to have_content("#{study_room_assignment.general_area} Assignment")
      expect(mail.html_part.body.to_s).to have_content(study_room_assignment.name)
      expect(mail.attachments.first.content_type).to eq('application/pdf; filename="Study Room Agreement.pdf"')
    end
  end

  describe '#study_room_violation' do
    let(:study_room_assignment) { FactoryBot.create(:study_room_assignment) }

    it 'sends an email to the assignee' do
      study_room_violation = StudyRoomViolation.new(study_room: study_room_assignment.study_room, user: study_room_assignment.user, number_of_books: 8)
      expect { described_class.with(study_room_violation:).study_room_violation.deliver }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Uncharged Materials in Study Room'
      expect(mail.to).to eq [study_room_violation.email]
      expect(mail.from).to eq ['access@princeton.edu']
      expect(mail.html_part.body.to_s).to have_content('Firestone Library Study Room Violation')
      expect(mail.html_part.body.to_s).to have_content("Today 8 books were found in your study room area #{study_room_violation.location} " \
                                                       'that were not checked out and we returned them to Circulation')
      expect(mail.attachments.first.content_type).to eq('application/pdf; filename="Study Room Agreement.pdf"')
    end
  end
end
