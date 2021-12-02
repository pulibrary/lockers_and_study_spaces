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

  describe '#from_uid' do
    it 'finds an existing user' do
      user1 = FactoryBot.create(:user)
      expect do
        User.from_uid(user1.uid)
      end.to change { User.count }.by(0)
    end

    it 'creates a new user' do
      expect do
        User.from_uid('abc123')
      end.to change { User.count }.by(1)
    end
  end
end
