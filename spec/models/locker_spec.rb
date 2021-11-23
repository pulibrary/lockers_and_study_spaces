# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Locker, type: :model do
  describe '#available_lockers' do
    let(:locker_application) {  FactoryBot.create :locker_application }
    let(:locker_assignment) { FactoryBot.create :locker_assignment, locker_application: locker_application, locker: locker1 }
    let(:locker1) {  FactoryBot.create :locker }
    let(:locker2) {  FactoryBot.create :locker }
    let(:locker3) {  FactoryBot.create :locker }

    before do
      locker_assignment
      locker2
      locker3
    end

    it 'to only returns unassigned lockers in area' do
      expect(described_class.available_lockers).to contain_exactly(locker2, locker3)
    end
  end
end
