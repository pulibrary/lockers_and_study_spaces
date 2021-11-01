# frozen_string_literal: true

json.extract! study_room, :id, :location, :general_area, :notes, :created_at, :updated_at
json.url study_room_url(study_room, format: :json)
