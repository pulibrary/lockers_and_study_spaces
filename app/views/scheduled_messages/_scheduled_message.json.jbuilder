# frozen_string_literal: true

json.extract! scheduled_message, :id, :schedule, :applicable_range, :template, :user_filter, :type, :results, :created_at, :updated_at
json.url scheduled_message_url(scheduled_message, format: :json)
