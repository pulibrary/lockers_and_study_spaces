# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyRoomViolationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/study_room_violations').to route_to('study_room_violations#index')
    end

    it 'routes to #new' do
      expect(get: '/study_room_violations/new').to route_to('study_room_violations#new')
    end

    it 'routes to #show' do
      expect(get: '/study_room_violations/1').to route_to('study_room_violations#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/study_room_violations/1/edit').to route_to('study_room_violations#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/study_room_violations').to route_to('study_room_violations#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/study_room_violations/1').to route_to('study_room_violations#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/study_room_violations/1').to route_to('study_room_violations#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/study_room_violations/1').to route_to('study_room_violations#destroy', id: '1')
    end
  end
end
