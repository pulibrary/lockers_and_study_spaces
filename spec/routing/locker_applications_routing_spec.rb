# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerApplicationsController, type: :routing do
  describe 'routing' do
    it 'routes the root of the application to the LockerApplications controller' do
      expect(get: '/').to route_to('locker_applications#new')
    end

    it 'routes to #index' do
      expect(get: '/locker_applications').to route_to('locker_applications#index')
    end

    it 'routes to #new' do
      expect(get: '/locker_applications/new').to route_to('locker_applications#new')
    end

    it 'routes to #show' do
      expect(get: '/locker_applications/1').to route_to('locker_applications#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/locker_applications/1/edit').to route_to('locker_applications#edit', id: '1')
    end

    it 'routes to #assign' do
      expect(get: '/locker_applications/1/assign').to route_to('locker_applications#assign', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/locker_applications').to route_to('locker_applications#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/locker_applications/1').to route_to('locker_applications#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/locker_applications/1').to route_to('locker_applications#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/locker_applications/1').to route_to('locker_applications#destroy', id: '1')
    end
  end
end
