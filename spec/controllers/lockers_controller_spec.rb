# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockersController do
  render_views
  let(:firestone) { FactoryBot.create(:building, name: 'Firestone Library') }
  let(:lewis) { FactoryBot.create(:building, name: 'Lewis Library') }
  let(:user) { FactoryBot.create(:user, :admin, building: lewis) }
  let(:firestone_locker) { FactoryBot.create(:locker, building: firestone) }
  let(:lewis_locker) { FactoryBot.create(:locker, building: lewis) }

  before do
    sign_in user
  end

  describe '#index' do
    before do
      firestone_locker
      lewis_locker
    end

    it "only includes lockers for the admin's building" do
      controller.index
      expect(controller.instance_variable_get('@lockers')).to include(lewis_locker)
      expect(controller.instance_variable_get('@lockers')).not_to include(firestone_locker)
    end
  end

  context 'when Lewis staff features are turned on' do
    before do
      allow(Flipflop).to receive(:lewis_staff?).and_return(true)
    end

    it 'a Lewis admin user can access the index screen' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when Lewis staff features are turned off' do
    before do
      allow(Flipflop).to receive(:lewis_staff?).and_return(false)
    end

    it 'a Lewis admin cannot access the index screen' do
      get :index
      expect(response).to redirect_to('/')
      expect(flash[:alert]).to eq('Only administrators have access to the specific Locker information!')
    end
  end
end
