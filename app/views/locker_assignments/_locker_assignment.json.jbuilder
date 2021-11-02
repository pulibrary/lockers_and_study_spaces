# frozen_string_literal: true

json.extract! locker_assignment, :id, :start_date, :expiration_date, :locker_application, :locker_id, :created_at, :updated_at
json.url locker_assignment_url(locker_assignment, format: :json)
