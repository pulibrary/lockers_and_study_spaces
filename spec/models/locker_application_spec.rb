# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerApplication, type: :model do
  subject(:locker_application) { described_class.new(user: user) }
  let(:user) { nil }
  it 'does not create an applicant' do
    expect(locker_application.applicant).to be_blank
  end

  it 'only has one size choice' do
    expect(locker_application.size_choices).to eq([4])
  end

  context 'a user is present' do
    let(:user) { FactoryBot.create(:user) }
    let(:applicant) { instance_double('Applicant', department: 'department', status: 'senior', junior?: false) }

    before do
      allow(Applicant).to receive(:new).and_return(applicant)
    end

    it 'creates an applicant' do
      expect(locker_application.applicant).to eq(applicant)
    end

    it 'only has multiple size choices' do
      expect(locker_application.size_choices).to eq([4, 6])
    end
  end

  context 'a junior user is present' do
    let(:user) { FactoryBot.create(:user) }
    let(:applicant) { instance_double('Applicant', department: 'department', status: 'junior', junior?: true) }

    before do
      allow(Applicant).to receive(:new).and_return(applicant)
    end

    it 'creates an applicant' do
      expect(locker_application.applicant).to eq(applicant)
    end

    it 'only has one size choice' do
      expect(locker_application.size_choices).to eq([4])
    end
  end
end
