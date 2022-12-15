# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockersController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/lockers').to route_to('lockers#index')
    end

    it 'routes to #new' do
      expect(get: '/lockers/new').to route_to('lockers#new')
    end

    it 'routes to #show' do
      expect(get: '/lockers/1').to route_to('lockers#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/lockers/1/edit').to route_to('lockers#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/lockers').to route_to('lockers#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/lockers/1').to route_to('lockers#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/lockers/1').to route_to('lockers#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/lockers/1').to route_to('lockers#destroy', id: '1')
    end
  end
end
