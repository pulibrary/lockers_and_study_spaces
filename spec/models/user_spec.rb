# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryBot.create(:user) }

  describe '#number_of_violations' do
    it "returns the user's number of violations" do
      FactoryBot.create(:locker_violation, user:)
      expect(user.number_of_violations).to eq(1)
    end

    it "returns the user's number of violations" do
      FactoryBot.create(:locker_violation, user:)
      FactoryBot.create(:locker_violation, user:)
      expect(user.number_of_violations).to eq(2)
    end
  end

  describe '#from_uid' do
    it 'finds an existing user' do
      user1 = FactoryBot.create(:user)
      expect do
        User.from_uid(user1.uid)
      end.not_to change { User.count }
    end

    it 'creates a new user' do
      expect do
        User.from_uid('abc123')
      end.to change { User.count }.by(1)
    end
  end

  describe '#from_email' do
    it 'finds an existing user' do
      user1 = FactoryBot.create(:user)
      expect do
        User.from_email(user1.uid)
      end.not_to change { User.count }
    end
  end

  describe '#from_cas' do
    let(:access_token) { OmniAuth::AuthHash.new(provider: 'cas', uid: 'myuid') }

    before do
      user.save!
    end

    context 'with existing cas user' do
      let(:user) { FactoryBot.create(:user, uid: 'myuid', provider: 'cas') }

      it 'returns the existing user' do
        expect(User.from_cas(access_token).uid).to eq('myuid')
      end
    end

    context 'with existing migration user' do
      let(:user) { FactoryBot.create(:user, uid: 'myuid', provider: 'migration') }

      it 'returns the existing user' do
        expect(User.from_cas(access_token).uid).to eq('myuid')
      end

      it 'does not add any additional users to the database' do
        expect(User.all.count).to eq(1)
        User.from_cas(access_token)
        expect(User.all.count).to eq(1)
      end

      it "does not modify the existing user's provider" do
        expect(User.from_cas(access_token).provider).to eq('migration')
      end
    end

    context 'user does not yet exist in the database' do
      let(:access_token) { OmniAuth::AuthHash.new(provider: 'cas', uid: 'aNewUser') }

      it 'creates a new user in the database' do
        expect(User.all.count).to eq(1)
        User.from_cas(access_token)
        expect(User.all.count).to eq(2)
      end
    end
  end

  describe '#works_at_enabled_building?' do
    let(:building) { FactoryBot.create(:building, name: 'Lewis Library') }
    let(:user) { FactoryBot.create(:user, admin: true, building:) }

    context 'when user is at Firestone' do
      let(:building) { FactoryBot.create(:building, name: 'Firestone Library') }

      it 'is true' do
        expect(user.works_at_enabled_building?).to be(true)
      end
    end

    context 'when user is at Lewis' do
      context 'when Lewis staff feature is turned on' do
        before do
          allow(Flipflop).to receive(:lewis_staff?).and_return(true)
        end

        it 'is true' do
          expect(user.works_at_enabled_building?).to be(true)
        end
      end

      context 'when Lewis staff feature is turned off' do
        before do
          allow(Flipflop).to receive(:lewis_staff?).and_return(false)
        end

        it 'is false' do
          expect(user.works_at_enabled_building?).to be(false)
        end
      end
    end

    context 'when user has no building' do
      let(:user) { FactoryBot.create(:user, admin: true, building: nil) }

      it 'is false' do
        expect(user.works_at_enabled_building?).to be(false)
      end
    end
  end
end
