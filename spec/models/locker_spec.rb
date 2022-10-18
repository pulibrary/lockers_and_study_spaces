# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Locker, type: :model do
  describe '#available_lockers' do
    let(:locker_application) {  FactoryBot.create :locker_application }
    let(:locker_assignment) { FactoryBot.create :locker_assignment, locker_application: locker_application, locker: locker1 }
    let(:locker1) {  FactoryBot.create :locker }
    let(:locker2) {  FactoryBot.create :locker }
    let(:locker3) {  FactoryBot.create :locker }
    let(:locker4) {  FactoryBot.create :locker }

    before do
      locker_assignment
      locker2
      locker3
      locker4
    end

    it 'to only returns unassigned lockers in area' do
      expect(described_class.available_lockers).to contain_exactly(locker2, locker3, locker4)
    end

    context 'disabled lockers' do
      let(:locker2) { FactoryBot.create :locker, disabled: true }
      let(:locker3) { FactoryBot.create :locker, disabled: false }
      let(:locker4) { FactoryBot.create :locker, disabled: nil }

      it 'does not include lockers that have been disabled' do
        expect(described_class.available_lockers).to contain_exactly(locker3, locker4)
      end
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
          FactoryBot.create(:locker, size: size, floor: floor)
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
          FactoryBot.create(:locker_assignment, locker: FactoryBot.create(:locker, size: size, floor: floor))
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
          FactoryBot.create(:locker_assignment, locker: FactoryBot.create(:locker, size: size, floor: floor))
        end
        FactoryBot.create(:locker, size: Locker.new.size_list.first, floor: floor, disabled: true)
      end
      expect(described_class.new.space_report).to eq({ "4' B floor" => [2, 1, 1, 0], "4' A floor" => [2, 1, 1, 0], "6' C floor" => [1, 1, 1, 0],
                                                       "6' B floor" => [1, 1, 1, 0], "4' 3rd floor" => [2, 1, 1, 0],
                                                       "4' C floor" => [2, 1, 1, 0], "6' A floor" => [1, 1, 1, 0], "6' 3rd floor" => [1, 1, 1, 0],
                                                       "4' 2nd floor" => [2, 1, 1, 0], "6' 2nd floor" => [1, 1, 1, 0] })
    end
  end
end
