# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feature dashboard' do
  let(:building) { FactoryBot.create(:building, name: 'Lewis Library') }
  let(:user) { FactoryBot.create(:user, :admin, building:) }

  context 'when user is an admin' do
    before do
      sign_in user
    end

    it 'can access the dashboard' do
      get '/flipflop'
      expect(response).to have_http_status :ok
      expect(response.body).to include('Locker And Study Spaces Features')
    end

    context 'when Lewis is not enabled' do
      before do
        allow(Flipflop).to receive(:lewis_staff?).and_return(false)
      end

      it 'can access the dashboard' do
        get '/flipflop'
        expect(response).to have_http_status :ok
        expect(response.body).to include('Locker And Study Spaces Features')
      end
    end
  end

  context 'when user is not an admin' do
    let(:user) { FactoryBot.create(:user, admin: false, building:) }

    before do
      sign_in user
    end

    it 'cannot access the dashboard' do
      get '/flipflop'
      expect(response).to have_http_status :forbidden
    end
  end

  context 'when user has not logged in yet' do
    it 'redirects to sign-in page' do
      get '/flipflop'
      expect(response).to redirect_to('/sign_in')
    end
  end
end
