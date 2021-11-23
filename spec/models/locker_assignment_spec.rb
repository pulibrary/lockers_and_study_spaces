# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerAssignment, type: :model do
  let(:locker_application1) { FactoryBot.create :locker_application }
  let(:locker_application2) { FactoryBot.create :locker_application }
  let(:locker_assignment1) do
    described_class.create(locker_application: locker_application2, locker: locker1, start_date: DateTime.now, expiration_date: DateTime.now.next_year)
  end
  let(:locker_assignment2) do
    described_class.create(locker_application: locker_application2, locker: locker4, start_date: DateTime.now, expiration_date: DateTime.now.next_year)
  end
  let(:locker1) {  FactoryBot.create :locker }
  let(:locker2) {  FactoryBot.create :locker }
  let(:locker3) {  FactoryBot.create :locker, floor: locker_application1.preferred_general_area }
  let(:locker4) {  FactoryBot.create :locker, floor: locker_application1.preferred_general_area }

  before do
    locker_assignment1
    locker_assignment2
    locker2
    locker3
  end

  describe '#locker_choices' do
    it 'has available lockers' do
      # contains locker 1 because that is assigned to this Assignment
      expect(locker_assignment1.locker_choices).to contain_exactly({ label: locker1.location, value: locker1.id },
                                                                   { label: locker2.location, value: locker2.id },
                                                                   { label: locker3.location, value: locker3.id })
    end
  end

  describe '#preferred_locker_choices' do
    it 'has available lockers' do
      # contains locker 1 because that is assigned to this Assignment
      expect(locker_assignment1.preferred_locker_choices).to contain_exactly({ label: locker1.location, value: locker1.id },
                                                                             { label: locker3.location, value: locker3.id })
    end
  end

  describe '##search' do
    let(:locker_application1) { FactoryBot.create(:locker_application, status_at_application: 'junior') }
    let(:locker_application2) { FactoryBot.create(:locker_application, status_at_application: 'senior') }
    let(:locker_application3) { FactoryBot.create(:locker_application, status_at_application: 'junior') }
    let(:locker_application4) { FactoryBot.create(:locker_application, user: locker_application1.user, status_at_application: 'senior') }
    let(:locker1) { FactoryBot.create(:locker, floor: 'A floor') }
    let(:locker2) { FactoryBot.create(:locker, floor: 'B floor') }
    let(:locker3) { FactoryBot.create(:locker, floor: 'B floor') }
    let!(:locker_assignment1) { FactoryBot.create :locker_assignment, locker_application: locker_application1, locker: locker1 }
    let!(:locker_assignment2) { FactoryBot.create :locker_assignment, locker_application: locker_application2, locker: locker2 }
    let!(:locker_assignment3) { FactoryBot.create :locker_assignment, locker_application: locker_application3, locker: locker3 }
    let!(:locker_assignment4) { FactoryBot.create :locker_assignment, locker_application: locker_application4, locker: locker1 }

    it 'searches by user netid' do
      expect(described_class.search(queries: { uid: locker_assignment1.uid })).to contain_exactly(locker_assignment1, locker_assignment4)
    end

    it 'searches returns all if search term is empty' do
      expect(described_class.search(queries: { uid: nil })).to contain_exactly(locker_assignment1, locker_assignment2, locker_assignment3,
                                                                               locker_assignment4)
    end

    it 'filters by status_at_application and floor (order does not matter)' do
      expect(described_class.search(queries: { floor: 'B floor', status_at_application: 'junior' })).to contain_exactly(locker_assignment3)
      expect(described_class.search(queries: { status_at_application: 'junior', floor: 'B floor' })).to contain_exactly(locker_assignment3)
    end

    it 'filters by user status_at_application and floor' do
      expect(described_class.search(queries: { uid: locker_assignment1.uid, floor: 'A floor',
                                               status_at_application: 'junior' })).to contain_exactly(locker_assignment1)
    end

    it 'ignores invalid queries' do
      expect(described_class.search(queries: { foo: 'bar', uid: locker_assignment1.uid, floor: 'A floor',
                                               status_at_application: 'junior' })).to contain_exactly(locker_assignment1)
    end
  end
end
