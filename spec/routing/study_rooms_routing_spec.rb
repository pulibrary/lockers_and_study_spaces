# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyRoomsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/study_rooms').to route_to('study_rooms#index')
    end

    it 'routes to #new' do
      expect(get: '/study_rooms/new').to route_to('study_rooms#new')
    end

    it 'routes to #show' do
      expect(get: '/study_rooms/1').to route_to('study_rooms#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/study_rooms/1/edit').to route_to('study_rooms#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/study_rooms').to route_to('study_rooms#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/study_rooms/1').to route_to('study_rooms#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/study_rooms/1').to route_to('study_rooms#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/study_rooms/1').to route_to('study_rooms#destroy', id: '1')
    end
  end
end
