# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerViolationsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/locker_violations').to route_to('locker_violations#index')
    end

    it 'routes to #new' do
      expect(get: '/locker_violations/new').to route_to('locker_violations#new')
    end

    it 'routes to #show' do
      expect(get: '/locker_violations/1').to route_to('locker_violations#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/locker_violations/1/edit').to route_to('locker_violations#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/locker_violations').to route_to('locker_violations#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/locker_violations/1').to route_to('locker_violations#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/locker_violations/1').to route_to('locker_violations#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/locker_violations/1').to route_to('locker_violations#destroy', id: '1')
    end
  end
end
