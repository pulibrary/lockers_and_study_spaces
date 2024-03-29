# frozen_string_literal: true

json.extract! locker_application, :id, :preferred_size, :preferred_general_area, :accessibility_needs, :semester,
              :status_at_application, :department_at_application, :user_id, :created_at, :updated_at
json.url locker_application_url(locker_application, format: :json)
