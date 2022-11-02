# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerApplication, type: :model do
  subject(:locker_application) { described_class.new(user: user) }

  let(:building_one) { FactoryBot.create(:building, id: 1) }
  let(:building_two) { FactoryBot.create(:building, name: 'Lewis Library', id: 2) }

  let(:user) { nil }
  let(:building) { FactoryBot.create(:building) }

  before do
    building_one
    building_two
  end

  it 'responds to the attributes' do
    expect(locker_application.user).to be_nil
    expect(locker_application.preferred_size).to be_nil
    expect(locker_application.accessible).to be_nil
    expect(locker_application.semester).to be_nil
    expect(locker_application.status_at_application).to be_nil
    expect(locker_application.department_at_application).to be_nil
    expect(locker_application.locker_assignment).to be_nil
    expect(locker_application.archived).to be(false)
    expect(locker_application.building).to eq(building_one)
    expect(locker_application.complete).to be false
  end

  context 'with an application created prior to having complete in the database' do
    subject(:locker_application) { described_class.new(user: user, complete: nil) }

    let(:user) { FactoryBot.create(:user) }

    it 'can mark the locker application as complete' do
      locker_application.save!
      expect(locker_application.reload.complete).to be_nil
      described_class.mark_applications_complete
      expect(locker_application.reload.complete).to be true
    end
  end

  describe '#available_lockers_in_area_and_size' do
    let(:locker_application) { FactoryBot.create :locker_application, preferred_size: 4 }
    let!(:locker_assignment) { FactoryBot.create :locker_assignment, locker_application: locker_application, locker: locker1 }
    let!(:locker1) {  FactoryBot.create :locker, size: 4 }
    let!(:locker2) {  FactoryBot.create :locker, size: 6 }
    let!(:locker3) {  FactoryBot.create :locker, floor: locker_application.preferred_general_area, size: 6 }
    let!(:locker4) {  FactoryBot.create :locker, floor: locker_application.preferred_general_area, size: 4 }

    it 'to only returns unassigned lockers in area of the right size' do
      expect(locker_application.available_lockers_in_area_and_size(building: building)).to contain_exactly(locker4)
    end

    context 'no size preference shows any' do
      let(:locker_application) { FactoryBot.create :locker_application, preferred_size: nil }

      it 'to only returns unassigned lockers in area' do
        expect(locker_application.available_lockers_in_area_and_size(building: building)).to contain_exactly(locker3, locker4)
      end
    end

    context 'no area preference shows any in size' do
      let(:locker_application) { FactoryBot.create :locker_application, preferred_size: 4, preferred_general_area: 'No preference' }

      it 'to only returns unassigned lockers in area' do
        expect(locker_application.available_lockers_in_area_and_size(building: building)).to contain_exactly(locker4)
      end
    end

    context 'disabled locker' do
      let(:locker3) { FactoryBot.create :locker, floor: locker_application.preferred_general_area, size: 4, disabled: true }

      it 'does not return a disabled locker, even if it otherwise meets the criteria' do
        expect(locker_application.available_lockers_in_area_and_size(building: building)).not_to include(locker3)
      end
    end
  end

  describe '##awaiting_assignment' do
    let(:locker_application1) { FactoryBot.create :locker_application, complete: true }
    let(:locker_application2) { FactoryBot.create :locker_application, complete: true }
    let(:locker_application3) { FactoryBot.create :locker_application, complete: true }
    let(:locker_application4) { FactoryBot.create :locker_application, complete: true, archived: true }
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
    expect(locker_application.size_choices).to eq([{ label: '4-foot', value: 4 }])
  end

  context 'a user is present' do
    let(:user) { FactoryBot.create(:user, applicant: applicant) }
    let(:applicant) { instance_double(Applicant, department: 'department', status: 'senior', junior?: false) }

    it 'knows the user is a senior' do
      expect(locker_application.status).to eq('senior')
    end

    it 'only has multiple size choices' do
      expect(locker_application.size_choices).to eq([{ label: '4-foot', value: 4 }, { label: '6-foot', value: 6 }])
    end
  end

  context 'a junior user is present' do
    let(:user) { FactoryBot.create(:user, applicant: applicant) }
    let(:applicant) { instance_double(Applicant, department: 'department', status: 'junior', junior?: true) }

    it 'knows the user is a junior' do
      expect(locker_application.status).to eq('junior')
    end

    it 'only has one size choice' do
      expect(locker_application.size_choices).to eq([{ label: '4-foot', value: 4 }])
    end
  end

  describe '##search' do
    let!(:locker_application1) { FactoryBot.create :locker_application, complete: true }
    let!(:locker_application2) { FactoryBot.create :locker_application, complete: true }
    let!(:locker_application3) { FactoryBot.create :locker_application, complete: true }

    it 'searches by user netid' do
      expect(described_class.search(uid: locker_application1.user.uid, archived: nil)).to contain_exactly(locker_application1)
    end

    it 'searches returns all if search term is empty' do
      expect(described_class.search(uid: nil, archived: false)).to contain_exactly(locker_application1, locker_application2, locker_application3)
    end
  end

  describe '##department_choices' do
    let!(:locker_application1) { FactoryBot.create :locker_application, complete: true }
    let!(:locker_application2) { FactoryBot.create :locker_application, complete: true }
    let!(:locker_application3) { FactoryBot.create :locker_application, complete: true }

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
