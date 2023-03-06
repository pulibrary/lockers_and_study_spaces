# frozen_string_literal: true

require 'rails_helper'
require 'rake'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'lockers rake tasks' do
  before do
    LockerAndStudySpaces::Application.load_tasks
  end

  describe 'Lewis lockers' do
    it 'adds all the required lockers' do
      expect do
        run_described_task
      end.to change(Locker, :count).by(104)
    end

    it 'creates valid locker locations' do
      run_described_task
      expect(Locker.all.pluck(:location)).to include(
        '301', '302', '310', '352',
        '401', '402', '410', '452'
      )
    end

    it 'assigns lockers to the correct floor' do
      run_described_task
      expect(Locker.find_by(location: '316').general_area).to eq('3rd floor')
      expect(Locker.find_by(location: '435').general_area).to eq('4th floor')
    end

    it 'sets the size of new Lewis lockers to 2 feet' do
      run_described_task
      expect(Locker.find_by(location: '316').size).to eq(2)
    end

    it 'does not add a Lewis locker if it already exists' do
      Locker.create! location: '401', general_area: '4th floor', building: Building.find_or_create_by(name: 'Lewis Library'), size: 2, floor: '4th floor'
      expect do
        run_described_task
      end.to change(Locker, :count).by(103)
    end

    context 'when the task has already been run' do
      before do
        run_described_task
      end

      it 'is idempotent' do
        expect do
          run_described_task
        end.not_to change(Locker, :count)
      end
    end
  end

  def run_described_task
    Rake::Task['lockers:lewis:seed'].invoke
    Rake::Task['lockers:lewis:seed'].clear
    Rake::Task['lockers:lewis:seed'].reenable
  end
end
# rubocop:enable RSpec/DescribeClass
