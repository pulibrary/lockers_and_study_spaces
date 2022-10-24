# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feature dashboard', type: :request do
  let(:building) { FactoryBot.create :building, name: 'Lewis Library' }
  let(:user) { FactoryBot.create :user, :admin, building: building }

  context 'admin user' do
    before do
      sign_in user
    end
    
    it 'can access the dashboard' do
      get '/flipflop'
      expect(response.status).to be 200
      expect(response.body).to include('Locker And Study Spaces Features')
    end
  end

  context 'non-admin user' do
    let(:user) { FactoryBot.create :user, admin: false, building: building }

    before do
      sign_in user
    end
    
    it 'cannot access the dashboard' do
      get '/flipflop'
      expect(response.status).to be 403
    end
  end

  context 'unauthenticated user' do
    it 'redirects to sign-in page' do
      get '/flipflop'
      expect(response).to redirect_to('/sign_in')
    end
  end

end
