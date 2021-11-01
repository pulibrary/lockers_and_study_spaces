# frozen_string_literal: true

json.extract! study_room_assignment, :id, :start_date, :end_date, :user_id, :study_room_id, :created_at, :updated_at
json.url study_room_assignment_url(study_room_assignment, format: :json)
