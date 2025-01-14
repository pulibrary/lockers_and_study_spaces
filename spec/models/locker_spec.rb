# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Locker do
  describe '#available_lockers' do
    let(:locker_application) {  FactoryBot.create(:locker_application) }
    let(:locker_assignment) { FactoryBot.create(:locker_assignment, locker_application:, locker: locker1) }
    let(:locker1) {  FactoryBot.create(:locker) }
    let(:locker2) {  FactoryBot.create(:locker) }
    let(:locker3) {  FactoryBot.create(:locker) }
    let(:locker4) {  FactoryBot.create(:locker) }
    let(:our_building) { FactoryBot.create(:building) }
    let(:other_building) { FactoryBot.create(:building, name: 'Other library') }

    before do
      locker_assignment
      locker2
      locker3
      locker4
    end

    it 'to only returns unassigned lockers in area' do
      expect(described_class.available_lockers(building: our_building)).to contain_exactly(locker2, locker3, locker4)
    end

    context 'disabled lockers' do
      let(:locker2) { FactoryBot.create(:locker, disabled: true) }
      let(:locker3) { FactoryBot.create(:locker, disabled: false) }
      let(:locker4) { FactoryBot.create(:locker, disabled: nil) }

      it 'does not include lockers that have been disabled' do
        expect(described_class.available_lockers(building: our_building)).to contain_exactly(locker3, locker4)
      end
    end

    context 'when lockers are at another building' do
      let(:locker2) { FactoryBot.create(:locker, building: other_building) }

      it "does not include the other building's lockers" do
        expect(described_class.available_lockers(building: our_building)).to contain_exactly(locker3, locker4)
      end
    end
  end

  describe '#floor_list' do
    before do
      allow(Flipflop).to receive(:lewis_patrons?).and_return(true)
    end

    it 'accepts an optional building param' do
      lewis = FactoryBot.create(:building, name: 'Lewis Library')
      expect(described_class.new.floor_list(building: lewis).count).to eq(2)
    end
  end

  describe '#size_floor_list' do
    it 'returns all the options combining floors with sizes' do
      expect(described_class.new.size_floor_list).to contain_exactly("4' A floor", "4' B floor", "4' C floor", "4' 2nd floor", "4' 3rd floor",
                                                                     "6' A floor", "6' B floor", "6' C floor", "6' 2nd floor", "6' 3rd floor")
    end
  end

  describe '#space_totals' do
    it 'returns all the spaces divided size and floor' do
      Locker.new.floor_list.each do |floor|
        Locker.new.size_list.each do |size|
          FactoryBot.create(:locker, size:, floor:)
        end
      end
      expect(described_class.new.space_totals).to eq({ "4' B floor" => 1, "4' A floor" => 1, "6' C floor" => 1,
                                                       "6' B floor" => 1, "4' 3rd floor" => 1,
                                                       "4' C floor" => 1, "6' A floor" => 1, "6' 3rd floor" => 1,
                                                       "4' 2nd floor" => 1, "6' 2nd floor" => 1 })
    end
  end

  describe '#space_assigned_totals' do
    it 'returns all the spaces divided size and floor if the are assigned to a user currently' do
      Locker.new.floor_list.each do |floor|
        Locker.new.size_list.each do |size|
          FactoryBot.create(:locker_assignment, locker: FactoryBot.create(:locker, size:, floor:))
        end
      end
      expect(described_class.new.space_assigned_totals).to eq({ "4' B floor" => 1, "4' A floor" => 1, "6' C floor" => 1,
                                                                "6' B floor" => 1, "4' 3rd floor" => 1,
                                                                "4' C floor" => 1, "6' A floor" => 1, "6' 3rd floor" => 1,
                                                                "4' 2nd floor" => 1, "6' 2nd floor" => 1 })
    end
  end

  describe '#space_report' do
    it 'returns all the spaces divided size and floor if the are assigned to a user currently' do
      Locker.new.floor_list.each do |floor|
        Locker.new.size_list.each do |size|
          FactoryBot.create(:locker_assignment, locker: FactoryBot.create(:locker, size:, floor:))
        end
        FactoryBot.create(:locker, size: Locker.new.size_list.first, floor:, disabled: true)
      end
      expect(described_class.new.space_report).to eq({ "4' B floor" => [2, 1, 1, 0], "4' A floor" => [2, 1, 1, 0], "6' C floor" => [1, 1, 1, 0],
                                                       "6' B floor" => [1, 1, 1, 0], "4' 3rd floor" => [2, 1, 1, 0],
                                                       "4' C floor" => [2, 1, 1, 0], "6' A floor" => [1, 1, 1, 0], "6' 3rd floor" => [1, 1, 1, 0],
                                                       "4' 2nd floor" => [2, 1, 1, 0], "6' 2nd floor" => [1, 1, 1, 0] })
    end
  end

  describe 'validation' do
    let(:firestone) { FactoryBot.create(:building, name: 'Firestone Library') }
    let(:lewis) { FactoryBot.create(:building, name: 'Lewis Library') }

    it 'cannot create a Firestone Locker without a combination' do
      expect { Locker.create! building: firestone, location: '123', general_area: 'by the staircase' }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'can create a Lewis Locker without a combination' do
      expect { Locker.create! building: lewis, location: '123', general_area: 'by the staircase' }.not_to raise_error
    end
  end
end
