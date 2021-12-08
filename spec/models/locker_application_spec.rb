# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerApplication, type: :model do
  subject(:locker_application) { described_class.new(user: user) }
  let(:user) { nil }

  it 'responds to the attributes' do
    expect(locker_application.user).to eq(nil)
    expect(locker_application.preferred_size).to eq(nil)
    expect(locker_application.accessible).to eq(nil)
    expect(locker_application.semester).to eq(nil)
    expect(locker_application.status_at_application).to eq(nil)
    expect(locker_application.department_at_application).to eq(nil)
    expect(locker_application.locker_assignment).to eq(nil)
  end

  describe '#available_lockers_in_area' do
    let(:locker_application) { FactoryBot.create :locker_application }
    let(:locker_assignment) { FactoryBot.create :locker_assignment, locker_application: locker_application, locker: locker1 }
    let(:locker1) {  FactoryBot.create :locker }
    let(:locker2) {  FactoryBot.create :locker }
    let(:locker3) {  FactoryBot.create :locker, floor: locker_application.preferred_general_area }

    before do
      locker_assignment
      locker2
      locker3
    end

    it 'to only returns unassigned lockers in area' do
      expect(locker_application.available_lockers_in_area).to contain_exactly(locker3)
    end
  end

  describe '##awaiting_assignment' do
    let(:locker_application1) { FactoryBot.create :locker_application }
    let(:locker_application2) { FactoryBot.create :locker_application }
    let(:locker_application3) { FactoryBot.create :locker_application }
    let(:locker_assignment) { FactoryBot.create :locker_assignment, locker_application: locker_application1, locker: locker1 }
    let(:locker1) { FactoryBot.create :locker }

    before do
      locker_assignment
      locker_application1
      locker_application2
    end
    it 'contains applications awaiting assignment' do
      expect(described_class.awaiting_assignment).to contain_exactly(locker_application2, locker_application3)
    end
  end

  it 'only has one size choice' do
    expect(locker_application.size_choices).to eq([{ label: 4, value: 4 }])
  end

  context 'a user is present' do
    let(:user) { FactoryBot.create(:user, applicant: applicant) }
    let(:applicant) { instance_double('Applicant', department: 'department', status: 'senior', junior?: false) }

    it 'knows the user is a senior' do
      expect(locker_application.status).to eq('senior')
    end

    it 'only has multiple size choices' do
      expect(locker_application.size_choices).to eq([{ label: 4, value: 4 }, { label: 6, value: 6 }])
    end
  end

  context 'a junior user is present' do
    let(:user) { FactoryBot.create(:user, applicant: applicant) }
    let(:applicant) { instance_double('Applicant', department: 'department', status: 'junior', junior?: true) }

    it 'knows the user is a junior' do
      expect(locker_application.status).to eq('junior')
    end

    it 'only has one size choice' do
      expect(locker_application.size_choices).to eq([{ label: 4, value: 4 }])
    end
  end

  describe '##search' do
    let!(:locker_application1) { FactoryBot.create :locker_application }
    let!(:locker_application2) { FactoryBot.create :locker_application }
    let!(:locker_application3) { FactoryBot.create :locker_application }

    it 'searches by user netid' do
      expect(described_class.search(uid: locker_application1.user.uid)).to contain_exactly(locker_application1)
    end

    it 'searches returns all if search term is empty' do
      expect(described_class.search(uid: nil)).to contain_exactly(locker_application1, locker_application2, locker_application3)
    end
  end

  describe '##department_choices' do
    let!(:locker_application1) { FactoryBot.create :locker_application }
    let!(:locker_application2) { FactoryBot.create :locker_application }
    let!(:locker_application3) { FactoryBot.create :locker_application }

    it 'shows all the departments' do
      expect(locker_application1.department_choices).to contain_exactly({ label: locker_application1.department_at_application,
                                                                          value: locker_application1.department_at_application },
                                                                        { label: locker_application2.department_at_application,
                                                                          value: locker_application2.department_at_application },
                                                                        { label: locker_application3.department_at_application,
                                                                          value: locker_application3.department_at_application })
    end
  end
end
