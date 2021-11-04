# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LockerAssignmentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/locker_assignments').to route_to('locker_assignments#index')
    end

    it 'routes to #show' do
      expect(get: '/locker_assignments/1').to route_to('locker_assignments#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/locker_assignments/1/edit').to route_to('locker_assignments#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/locker_assignments').to route_to('locker_assignments#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/locker_assignments/1').to route_to('locker_assignments#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/locker_assignments/1').to route_to('locker_assignments#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/locker_assignments/1').to route_to('locker_assignments#destroy', id: '1')
    end
  end
end
