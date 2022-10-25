# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerApplicationsController do
  render_views
  let(:building) { FactoryBot.create :building, name: 'Lewis Library' }
  let(:user) { FactoryBot.create :user, :admin, building: building }

  before do
    sign_in user
  end

  context 'when Lewis staff features are turned on' do
    before do
      allow(Flipflop).to receive(:lewis_staff?).and_return(true)
    end

    it 'a Lewis admin user can access the awaiting_assignment screen' do
      get :awaiting_assignment
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when Lewis staff features are turned off' do
    before do
      allow(Flipflop).to receive(:lewis_staff?).and_return(false)
    end

    it 'a Lewis admin cannot access the awaiting_assignment screen' do
      get :awaiting_assignment
      expect(response).to redirect_to('/')
      expect(flash[:alert]).to eq('Only administrators have access to the everyone\'s Locker Applications!')
    end
  end

  context 'when awaiting assignment' do
    let(:nil_mock) do
      ActionController::Parameters.new({ archived: nil })
    end
    let(:false_mock) do
      ActionController::Parameters.new({ archived: 'false' })
    end
    let(:true_mock) do
      ActionController::Parameters.new({ archived: 'true' })
    end

    it 'archived_param should return false for nil param' do
      allow(controller).to receive(:params).and_return(nil_mock)
      controller.awaiting_assignment
      expect(controller.instance_variable_get('@archived')).to be(false)
    end

    it 'archived_param should return false for false param' do
      allow(controller).to receive(:params).and_return(false_mock)
      controller.awaiting_assignment
      expect(controller.instance_variable_get('@archived')).to be(false)
    end

    it 'archived_param should return true for true param' do
      allow(controller).to receive(:params).and_return(true_mock)
      controller.awaiting_assignment
      expect(controller.instance_variable_get('@archived')).to be(true)
    end
  end
end
