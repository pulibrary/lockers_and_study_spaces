# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyRoomViolation do
  describe '#number_of_violations' do
    it "returns the user's number of violations" do
      study_room_violation = FactoryBot.create(:study_room_violation)
      expect(study_room_violation.number_of_violations).to eq(1)
    end

    it "returns the user's number of violations either study room or locker" do
      study_room_violation = FactoryBot.create(:study_room_violation)
      FactoryBot.create(:locker_violation, user: study_room_violation.user)
      expect(study_room_violation.number_of_violations).to eq(2)
    end
  end
end
