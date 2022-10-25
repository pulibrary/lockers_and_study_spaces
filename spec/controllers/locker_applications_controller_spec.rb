# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerApplicationsController do
  render_views
  let(:user) { FactoryBot.create :user, :admin }

  before do
    sign_in user
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
      expect(controller.instance_variable_get('@archived')).to eq(false)
    end

    it 'archived_param should return false for false param' do
      allow(controller).to receive(:params).and_return(false_mock)
      controller.awaiting_assignment
      expect(controller.instance_variable_get('@archived')).to eq(false)
    end

    it 'archived_param should return true for true param' do
      allow(controller).to receive(:params).and_return(true_mock)
      controller.awaiting_assignment
      expect(controller.instance_variable_get('@archived')).to eq(true)
    end
  end
end
