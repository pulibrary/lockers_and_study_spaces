# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerViolationsController do
  render_views
  let(:building) { FactoryBot.create(:building, name: 'Lewis Library') }
  let(:user) { FactoryBot.create(:user, :admin, building:) }

  before do
    sign_in user
  end

  context 'when logged in as a Lewis admin' do
    it 'a Lewis admin user can access the index screen' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
