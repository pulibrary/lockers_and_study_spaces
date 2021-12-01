# frozen_string_literal: true

json.extract! violation, :id, :locker_id, :user_id, :number_of_books, :created_at, :updated_at
json.url violation_url(violation, format: :json)
