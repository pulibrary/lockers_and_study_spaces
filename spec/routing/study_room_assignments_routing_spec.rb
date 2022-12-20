# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyRoomAssignmentsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/study_room_assignments').to route_to('study_room_assignments#index')
    end

    it 'routes to #new' do
      expect(get: '/study_room_assignments/new').to route_to('study_room_assignments#new')
    end

    it 'routes to #show' do
      expect(get: '/study_room_assignments/1').to route_to('study_room_assignments#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/study_room_assignments/1/edit').to route_to('study_room_assignments#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/study_room_assignments').to route_to('study_room_assignments#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/study_room_assignments/1').to route_to('study_room_assignments#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/study_room_assignments/1').to route_to('study_room_assignments#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/study_room_assignments/1').to route_to('study_room_assignments#destroy', id: '1')
    end
  end
end
