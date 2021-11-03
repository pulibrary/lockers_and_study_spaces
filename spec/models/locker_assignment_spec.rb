# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerAssignment, type: :model do
  let(:locker_application1) { FactoryBot.create :locker_application }
  let(:locker_application2) { FactoryBot.create :locker_application }
  let(:locker_assignment1) { described_class.create(locker_application: locker_application2, locker: locker1, start_date: DateTime.now) }
  let(:locker_assignment2) { described_class.create(locker_application: locker_application2, locker: locker4, start_date: DateTime.now) }
  let(:locker1) {  FactoryBot.create :locker }
  let(:locker2) {  FactoryBot.create :locker }
  let(:locker3) {  FactoryBot.create :locker, general_area: locker_application1.preferred_general_area }
  let(:locker4) {  FactoryBot.create :locker, general_area: locker_application1.preferred_general_area }

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
end
