# frozen_string_literal: true

json.extract! locker, :id, :location, :size, :general_area, :accessible, :notes, :combination, :code, :tag, :discs,
              :clutch, :hubpos, :key_number, :floor, :created_at, :updated_at
json.url locker_url(locker, format: :json)
