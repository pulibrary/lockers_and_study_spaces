# frozen_string_literal: true

json.extract! study_room_violation, :id, :user_id, :study_room_id, :number_of_books, :created_at, :updated_at
json.url study_room_violation_url(study_room_violation, format: :json)
