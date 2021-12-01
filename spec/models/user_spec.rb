# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }

  describe '#number_of_violations' do
    it "returns the user's number of violations" do
      FactoryBot.create(:locker_violation, user: user)
      expect(user.number_of_violations).to eq(1)
    end

    it "returns the user's number of violations" do
      FactoryBot.create(:locker_violation, user: user)
      FactoryBot.create(:locker_violation, user: user)
      expect(user.number_of_violations).to eq(2)
    end
  end
end
