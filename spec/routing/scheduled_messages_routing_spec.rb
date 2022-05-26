# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledMessagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/locker_renewal_messages').to route_to('locker_renewal_messages#index')
    end

    it 'routes to #new' do
      expect(get: '/locker_renewal_messages/new').to route_to('locker_renewal_messages#new')
    end

    it 'routes to #show' do
      expect(get: '/locker_renewal_messages/1').to route_to('locker_renewal_messages#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/locker_renewal_messages/1/edit').to route_to('locker_renewal_messages#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/locker_renewal_messages').to route_to('locker_renewal_messages#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/locker_renewal_messages/1').to route_to('locker_renewal_messages#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/locker_renewal_messages/1').to route_to('locker_renewal_messages#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/locker_renewal_messages/1').to route_to('locker_renewal_messages#destroy', id: '1')
    end
  end
end
