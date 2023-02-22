# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerApplication do
  subject(:locker_application) { described_class.new(user:) }

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
    expect(locker_application.accessibility_needs).to be_empty
  end

  context 'with an application created prior to having complete in the database' do
    subject(:locker_application) { described_class.new(user:, complete: nil) }

    let(:user) { FactoryBot.create(:user) }

    it 'can mark the locker application as complete' do
      locker_application.save!
      expect(locker_application.reload.complete).to be_nil
      described_class.mark_applications_complete
      expect(locker_application.reload.complete).to be true
    end
  end

  context 'with an application with an unspecified accessibility need' do
    subject(:locker_application) { described_class.new(user:, accessible: true, complete: true) }

    let(:user) { FactoryBot.create(:user) }

    context 'with an unassigned locker' do
      it 'can add the info to the accessibility_needs field' do
        locker_application.save!
        expect(described_class.awaiting_assignment).not_to be_empty
        expect(locker_application.accessible).to be true
        expect(locker_application.accessibility_needs).to be_empty
        described_class.migrate_accessible_field
        expect(locker_application.reload.accessibility_needs.first).to eq('Unspecified accessibility need')
      end

      context 'with both unspecific and specific accessibility needs' do
        subject(:locker_application) { described_class.new(user:, accessible: true, accessibility_needs: ['Near an elevator'], complete: true) }

        it 'can add the info to the accessibility_needs field' do
          locker_application.save!
          expect(described_class.awaiting_assignment).not_to be_empty
          expect(locker_application.accessible).to be true
          expect(locker_application.accessibility_needs).to match_array(['Near an elevator'])
          described_class.migrate_accessible_field
          expect(locker_application.reload.accessibility_needs).to match_array(['Unspecified accessibility need', 'Near an elevator'])
        end
      end
    end

    context 'with an assigned locker' do
      let!(:locker_assignment) { FactoryBot.create(:locker_assignment, locker_application:, locker: locker1) }
      let!(:locker1) { FactoryBot.create(:locker, size: 4) }

      it 'does not change the accessibility_needs' do
        locker_application.save!
        expect(described_class.awaiting_assignment).to be_empty
        expect(locker_application.accessible).to be true
        expect(locker_application.accessibility_needs).to be_empty
        described_class.migrate_accessible_field
        expect(locker_application.reload.accessibility_needs).to be_empty
      end
    end
  end

  describe '#accessibility_needs_choices' do
    it 'can list accessiblity choices' do
      expect(locker_application.accessibility_needs_choices).to be_an_instance_of(Array)
      expect(locker_application.accessibility_needs_choices.first).to be_an_instance_of(Hash)
      expect(locker_application.accessibility_needs_choices.first.keys).to match_array(%i[id description])
      expect(locker_application.accessibility_needs_choices.first[:id]).to eq('keyed_entry')
      expect(locker_application.accessibility_needs_choices.first[:description]).to eq('Keyed entry (rather than combination)')
    end
  end

  describe '#available_lockers_in_area_and_size' do
    let(:locker_application) { FactoryBot.create(:locker_application, preferred_size: 4) }
    let!(:locker_assignment) { FactoryBot.create(:locker_assignment, locker_application:, locker: locker1) }
    let!(:locker1) {  FactoryBot.create(:locker, size: 4) }
    let!(:locker2) {  FactoryBot.create(:locker, size: 6) }
    let!(:locker3) {  FactoryBot.create(:locker, floor: locker_application.preferred_general_area, size: 6) }
    let!(:locker4) {  FactoryBot.create(:locker, floor: locker_application.preferred_general_area, size: 4) }

    it 'to only returns unassigned lockers in area of the right size' do
      expect(locker_application.available_lockers_in_area_and_size(building:)).to contain_exactly(locker4)
    end

    context 'no size preference shows any' do
      let(:locker_application) { FactoryBot.create(:locker_application, preferred_size: nil) }

      it 'to only returns unassigned lockers in area' do
        expect(locker_application.available_lockers_in_area_and_size(building:)).to contain_exactly(locker3, locker4)
      end
    end

    context 'no area preference shows any in size' do
      let(:locker_application) { FactoryBot.create(:locker_application, preferred_size: 4, preferred_general_area: 'No preference') }

      it 'to only returns unassigned lockers in area' do
        expect(locker_application.available_lockers_in_area_and_size(building:)).to contain_exactly(locker4)
      end
    end

    context 'disabled locker' do
      let(:locker3) { FactoryBot.create(:locker, floor: locker_application.preferred_general_area, size: 4, disabled: true) }

      it 'does not return a disabled locker, even if it otherwise meets the criteria' do
        expect(locker_application.available_lockers_in_area_and_size(building:)).not_to include(locker3)
      end
    end
  end

  describe '##awaiting_assignment' do
    let(:locker_application1) { FactoryBot.create(:locker_application, complete: true) }
    let(:locker_application2) { FactoryBot.create(:locker_application, complete: true) }
    let(:locker_application3) { FactoryBot.create(:locker_application, complete: true) }
    let(:locker_application4) { FactoryBot.create(:locker_application, complete: true, archived: true) }
    let(:locker_assignment) { FactoryBot.create(:locker_assignment, locker_application: locker_application1, locker: locker1) }
    let(:locker1) { FactoryBot.create(:locker) }

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
    expect(locker_application.size_choices(building_one.name)).to eq([{ label: '4-foot', value: 4 }])
  end

  context 'a user is present' do
    let(:user) { FactoryBot.create(:user, applicant:) }
    let(:applicant) { instance_double(Applicant, department: 'department', status: 'senior', junior?: false) }

    it 'knows the user is a senior' do
      expect(locker_application.status).to eq('senior')
    end

    it 'only has multiple size choices' do
      expect(locker_application.size_choices(building_one.name)).to eq([{ label: '4-foot', value: 4 }, { label: '6-foot', value: 6 }])
    end
  end

  context 'a junior user is present' do
    let(:user) { FactoryBot.create(:user, applicant:) }
    let(:applicant) { instance_double(Applicant, department: 'department', status: 'junior', junior?: true) }

    it 'knows the user is a junior' do
      expect(locker_application.status).to eq('junior')
    end

    it 'only has one size choice' do
      expect(locker_application.size_choices(building_one.name)).to eq([{ label: '4-foot', value: 4 }])
    end
  end

  describe '##search' do
    let!(:locker_application1) { FactoryBot.create(:locker_application, complete: true) }
    let!(:locker_application2) { FactoryBot.create(:locker_application, complete: true) }
    let!(:locker_application3) { FactoryBot.create(:locker_application, complete: true) }
    let!(:locker_application4) { FactoryBot.create(:locker_application, complete: false) }
    let!(:locker_application5) { FactoryBot.create(:locker_application, complete: true, archived: true) }
    let!(:locker_application6) { FactoryBot.create(:locker_application, complete: true, building: building_two) }

    it 'searches by user netid' do
      expect(described_class.search(uid: locker_application1.user.uid, archived: nil, building_id: 1)).to contain_exactly(locker_application1)
    end

    it 'searches returns all if search term is empty' do
      expect(described_class.search(uid: nil, archived: false,
                                    building_id: 1)).to contain_exactly(locker_application1, locker_application2,
                                                                        locker_application3)
    end

    it 'searches returns archived results if archived is true' do
      expect(described_class.search(uid: nil, archived: true, building_id: 1)).to contain_exactly(locker_application1, locker_application2,
                                                                                                  locker_application3, locker_application5)
    end

    it 'searches by building_id' do
      expect(described_class.search(uid: nil, archived: false, building_id: 2)).to contain_exactly(locker_application6)
    end
  end

  describe '##department_choices' do
    let!(:locker_application1) { FactoryBot.create(:locker_application, complete: true) }
    let!(:locker_application2) { FactoryBot.create(:locker_application, complete: true) }
    let!(:locker_application3) { FactoryBot.create(:locker_application, complete: true) }

    it 'shows all the departments' do
      expect(locker_application1.department_choices).to contain_exactly({ label: locker_application1.department_at_application,
                                                                          value: locker_application1.department_at_application },
                                                                        { label: locker_application2.department_at_application,
                                                                          value: locker_application2.department_at_application },
                                                                        { label: locker_application3.department_at_application,
                                                                          value: locker_application3.department_at_application })
    end
  end

  describe '#duplicate_applications' do
    let(:user) { FactoryBot.create(:user) }
    let(:locker_application1) { FactoryBot.create(:locker_application, complete: true, user:) }
    let(:locker_application2) { FactoryBot.create(:locker_application, complete: true, user:) }

    before { locker_application1 && locker_application2 }

    it 'provides a list of applications that appear to be its duplicates' do
      expect(locker_application1.duplicates).to contain_exactly(locker_application2)
    end

    context 'when one application is not yet complete' do
      let(:locker_application2) { FactoryBot.create(:locker_application, complete: false, user:) }

      it 'is not considered a duplicate' do
        expect(locker_application1.duplicates).to be_empty
      end
    end

    context 'when one application is archived' do
      let(:locker_application2) { FactoryBot.create(:locker_application, complete: true, archived: true, user:) }

      it 'is not considered a duplicate' do
        expect(locker_application1.duplicates).to be_empty
      end
    end

    context 'when application is attached to an assignment' do
      let(:locker) { FactoryBot.create(:locker) }
      let(:locker_assignment) do
        LockerAssignment.create(locker_application: locker_application2, locker:, start_date: 1.year.ago, expiration_date: 1.day.ago)
      end

      it 'is considered a duplicate' do
        expect(locker_application1.duplicates).to contain_exactly(locker_application2)
      end

      context 'when the assignment is released' do
        before { locker_assignment.release }

        it 'is not considered a duplicate' do
          expect(locker_application1.duplicates).to be_empty
        end
      end
    end

    context 'when one application is at a different building' do
      let(:locker_application2) { FactoryBot.create(:locker_application, complete: true, user:, building: building_two) }

      it 'is considered a duplicate' do
        expect(locker_application1.duplicates).to contain_exactly(locker_application2)
      end
    end
  end
end
