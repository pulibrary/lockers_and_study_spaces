# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_assignments/card' do
  let(:building_one) { FactoryBot.create(:building, id: 1) }
  let(:building_two) { FactoryBot.create(:building, name: 'Lewis Library', id: 2) }

  before do
    @locker_assignment = assign(:locker_assignment, FactoryBot.create(:locker_assignment,
                                                                      locker_application:,
                                                                      locker:))
  end

  context 'with lewis_patrons on' do
    before do
      allow(Flipflop).to receive_messages(lewis_patrons?: true, lewis_staff?: true)
    end

    context 'with firestone_locker_assignment' do
      let(:locker) { FactoryBot.create(:locker, building: building_one) }
      let(:locker_application) { FactoryBot.create(:locker_application, building: building_one) }

      it 'shows a print view of the locker assignment' do
        render
        expect(rendered).to match(/Firestone Library/)
      end
    end

    context 'with lewis_locker_assignment' do
      let(:locker) { FactoryBot.create(:locker, building: building_two) }
      let(:locker_application) { FactoryBot.create(:locker_application, building: building_two) }

      it 'shows a print view of the locker assignment' do
        render
        expect(rendered).to match(/Lewis Library/)
      end
    end
  end
end
