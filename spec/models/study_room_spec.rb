# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyRoom, type: :model do
  let(:study_room) { FactoryBot.create :study_room }

  describe '#current_assignment' do
    it 'returns nil if no assignment exists' do
      expect(study_room.current_assignment).to be_nil
    end

    it 'returns the assignment if it exists' do
      assignment = FactoryBot.create :study_room_assignment
      expect(assignment.study_room.current_assignment).to eq(assignment)
    end
  end

  describe '#current_uid' do
    it 'returns an empty string if no assignment exists' do
      expect(study_room.current_uid).to eq('')
    end

    it 'returns the assignment if it exists' do
      assignment = FactoryBot.create :study_room_assignment
      expect(assignment.study_room.current_uid).to eq(assignment.uid)
    end
  end

  describe '#assign_user' do
    it 'noop if assignment already exists' do
      assignment = FactoryBot.create :study_room_assignment
      expect do
        assignment.study_room.assign_user(assignment.study_room.current_uid)
      end.to change { StudyRoomAssignment.count }.by(0)
                                                 .and change { User.count }.by(0)
    end

    it 'create a user if needed' do
      expect do
        study_room.assign_user('abc123')
      end.to change { StudyRoomAssignment.count }.by(1)
                                                 .and change { User.count }.by(1)
    end

    it 'release a previous assignment if needed' do
      assignment = FactoryBot.create :study_room_assignment
      expect do
        assignment.study_room.assign_user('abc123')
      end.to change { StudyRoomAssignment.count }.by(1)
                                                 .and change { User.count }.by(1)
      expect(assignment.reload.released_date).to eq(DateTime.now.to_date)
    end
  end

  describe '#space_totals' do
    it 'returns all the spaces divided size and floor' do
      described_class.general_areas.each do |general_area|
        FactoryBot.create(:study_room, general_area: general_area)
      end
      expect(described_class.new.space_totals).to eq({ 'Classics Graduate Study Room' => 1,
                                                       'History Graduate Study Room' => 1 })
    end
  end

  describe '#space_totals' do
    it 'returns all the spaces divided size and floor' do
      described_class.general_areas.each do |general_area|
        FactoryBot.create(:study_room_assignment, study_room: FactoryBot.create(:study_room, general_area: general_area))
      end
      expect(described_class.new.space_assigned_totals).to eq({ 'Classics Graduate Study Room' => 1,
                                                                'History Graduate Study Room' => 1 })
    end
  end

  describe '#space_report' do
    it 'returns all the spaces divided size and floor' do
      described_class.general_areas.each do |general_area|
        FactoryBot.create(:study_room_assignment, study_room: FactoryBot.create(:study_room, general_area: general_area))
      end
      expect(described_class.new.space_report).to eq({ 'Classics Graduate Study Room' => [1, 1, 1, 0],
                                                       'History Graduate Study Room' => [1, 1, 1, 0] })
    end
  end
end
