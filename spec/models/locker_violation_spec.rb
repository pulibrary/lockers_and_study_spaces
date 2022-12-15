# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerViolation do
  describe '#number_of_violations' do
    it "returns the user's number of violations" do
      locker_violation = FactoryBot.create(:locker_violation)
      expect(locker_violation.number_of_violations).to eq(1)
    end

    it "returns the user's number of violations either locker or study room" do
      locker_violation = FactoryBot.create(:locker_violation)
      FactoryBot.create(:study_room_violation, user: locker_violation.user)
      expect(locker_violation.number_of_violations).to eq(2)
    end
  end
end
