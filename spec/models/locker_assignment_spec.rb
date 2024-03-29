# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerAssignment do
  let(:locker_application1) { FactoryBot.create(:locker_application) }
  let(:locker_application2) { FactoryBot.create(:locker_application) }
  let(:locker_assignment1) do
    described_class.create(locker_application: locker_application2, locker: locker1, start_date: DateTime.now, expiration_date: DateTime.now.next_year)
  end
  let(:locker_assignment2) do
    described_class.create(locker_application: locker_application2, locker: locker4, start_date: DateTime.now, expiration_date: DateTime.now.next_year)
  end
  let(:locker1) {  FactoryBot.create(:locker) }
  let(:locker2) {  FactoryBot.create(:locker) }
  let(:locker3) {  FactoryBot.create(:locker, floor: locker_application1.preferred_general_area) }
  let(:locker4) {  FactoryBot.create(:locker, floor: locker_application1.preferred_general_area) }
  let(:our_building) { FactoryBot.create(:building) }
  let(:other_building) { FactoryBot.create(:building, name: 'Other library') }

  before do
    locker_assignment1
    locker_assignment2
    locker2
    locker3
  end

  describe '#locker_choices' do
    it 'has available lockers' do
      # contains locker 1 because that is assigned to this Assignment
      expect(locker_assignment1.locker_choices(building: our_building)).to contain_exactly(
        { label: "#{locker1.location} (#{locker1.size}')", value: locker1.id },
        { label: "#{locker2.location} (#{locker2.size}')", value: locker2.id },
        { label: "#{locker3.location} (#{locker3.size}')", value: locker3.id }
      )
    end

    context 'when a locker is owned by another building' do
      let(:locker2) { FactoryBot.create(:locker, building: other_building) }

      it "does not include the other building's locker" do
        expect(locker_assignment1.locker_choices(building: our_building)).to contain_exactly(
          { label: "#{locker1.location} (#{locker1.size}')", value: locker1.id },
          { label: "#{locker3.location} (#{locker3.size}')", value: locker3.id }
        )
      end
    end
  end

  describe '#preferred_locker_choices' do
    it 'has available lockers' do
      # contains locker 1 because that is assigned to this Assignment
      expect(locker_assignment1.preferred_locker_choices(building: our_building)).to contain_exactly(
        { label: "#{locker1.location} (#{locker1.size}')", value: locker1.id },
        { label: "#{locker3.location} (#{locker3.size}')", value: locker3.id }
      )
    end
  end

  describe '#release' do
    it 'releases the locker assignment' do
      expect(locker_assignment1.released_date).to be_nil
      locker_assignment1.release
      expect(locker_assignment1.released_date).to eq(DateTime.now.to_date)
    end

    it 'sets the expired date' do
      expect(locker_assignment1.expiration_date.year).to eq(DateTime.now.next_year.year)
      locker_assignment1.release
      expect(locker_assignment1.expiration_date).to eq(locker_assignment1.released_date)
    end
  end

  describe '#search' do
    let(:locker_application1) { FactoryBot.create(:locker_application, status_at_application: 'junior', department_at_application: 'History Department') }
    let(:locker_application2) { FactoryBot.create(:locker_application, status_at_application: 'senior', department_at_application: 'Math Department') }
    let(:locker_application3) { FactoryBot.create(:locker_application, status_at_application: 'junior', department_at_application: 'History Department') }
    let(:locker_application4) { FactoryBot.create(:locker_application, user: locker_application1.user, status_at_application: 'senior') }
    let(:locker1) { FactoryBot.create(:locker, floor: 'A floor') }
    let(:locker2) { FactoryBot.create(:locker, floor: 'B floor') }
    let(:locker3) { FactoryBot.create(:locker, floor: 'B floor') }
    let(:yesterday) { DateTime.yesterday.to_date }
    let(:today) { DateTime.now.to_date }
    let!(:locker_assignment1) do
      FactoryBot.create(:locker_assignment, locker_application: locker_application1, locker: locker1, expiration_date: today)
    end
    let!(:locker_assignment2) do
      FactoryBot.create(:locker_assignment, locker_application: locker_application2, locker: locker2, expiration_date: (DateTime.now + 1.day).to_date)
    end
    let!(:locker_assignment3) do
      FactoryBot.create(:locker_assignment, locker_application: locker_application3, locker: locker3, expiration_date: (DateTime.now + 5.days).to_date)
    end
    let!(:locker_assignment4) do
      FactoryBot.create(:locker_assignment, locker_application: locker_application4, locker: locker1, expiration_date: DateTime.yesterday.to_date)
    end

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

    it 'filters by department_at_application and floor (order does not matter)' do
      expect(described_class.search(queries: { floor: 'B floor',
                                               department_at_application: 'History Department' })).to contain_exactly(locker_assignment3)
      expect(described_class.search(queries: { department_at_application: 'History Department',
                                               floor: 'B floor' })).to contain_exactly(locker_assignment3)
    end

    it 'filters by user status_at_application and floor' do
      expect(described_class.search(queries: { uid: locker_assignment1.uid, floor: 'A floor',
                                               status_at_application: 'junior' })).to contain_exactly(locker_assignment1)
    end

    it 'filters by active (non expired)' do
      expect(described_class.search(queries: { active: true })).to contain_exactly(locker_assignment2, locker_assignment3)
    end

    it 'filters by a start of expiration dates)' do
      expect(described_class.search(queries: { expiration_date_start: DateTime.now })).to contain_exactly(locker_assignment1, locker_assignment2,
                                                                                                          locker_assignment3)
    end

    it 'filters by an end of expiration dates)' do
      expect(described_class.search(queries: { expiration_date_end: DateTime.now })).to contain_exactly(locker_assignment1, locker_assignment4)
    end

    it 'filters by a range of expiration dates)' do
      expect(described_class.search(queries: { expiration_date_start: DateTime.now,
                                               expiration_date_end: DateTime.tomorrow })).to contain_exactly(locker_assignment1, locker_assignment2)
    end

    it 'filters by a range with one day of expiration dates)' do
      expect(described_class.search(queries: { expiration_date_start: today,
                                               expiration_date_end: today })).to contain_exactly(locker_assignment1)
    end

    it 'ignores invalid queries' do
      expect(described_class.search(queries: { foo: 'bar', uid: locker_assignment1.uid, floor: 'A floor',
                                               status_at_application: 'junior' })).to contain_exactly(locker_assignment1)
    end
  end

  describe '#not_a_senior_or_faculty' do
    let(:user) { FactoryBot.create(:user) }
    let(:locker_application2) { FactoryBot.create(:locker_application, user:) }

    context 'for juniors' do
      it 'returns true' do
        allow(user).to receive(:status).and_return('junior')
        expect(locker_assignment2.not_a_senior_or_faculty).to be true
      end
    end

    context 'for seniors' do
      let(:status) { 'senior' }

      it 'returns false' do
        allow(user).to receive(:status).and_return('senior')
        expect(locker_assignment2.not_a_senior_or_faculty).to be false
      end
    end
  end
end
