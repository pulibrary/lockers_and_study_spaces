# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Building, type: :model do
  describe '#seed' do
    context 'when no buildings exist yet in the database' do
      let(:user) { FactoryBot.create :user, :admin, building: nil }
      let(:locker) { FactoryBot.create :locker, building: nil }

      before do
        described_class.destroy_all
        user.save && user.reload
        locker.save && locker.reload
      end

      it 'adds two buildings' do
        expect(described_class.all.count).to eq(0)
        described_class.seed
        expect(described_class.all.count).to eq(2)
      end

      it 'attaches all unattached lockers to Firestone' do
        described_class.seed
        expect(locker.reload.building).to eq firestone
      end

      it 'attaches all unattached admin users to Firestone' do
        described_class.seed
        expect(user.reload.building).to eq firestone
      end

      context 'when locker already assigned to Lewis' do
        let(:locker) do
          described_class.seed
          FactoryBot.create :locker, building: lewis
        end

        it 'keeps it at lewis' do
          expect(locker.reload.building).to eq lewis
        end
      end

      context 'when an admin user already attached to Lewis' do
        let(:user) do
          described_class.seed
          FactoryBot.create :user, :admin, building: lewis
        end

        it 'keeps them at lewis' do
          expect(user.reload.building).to eq lewis
        end
      end
    end

    context 'when buildings have already been seeded' do
      it 'does not add any additional buildings' do
        described_class.seed
        expect(described_class.all.count).to eq(2)
      end
    end
  end
end

def firestone
  Building.find_by(name: 'Firestone Library')
end

def lewis
  Building.find_by(name: 'Lewis Library')
end
