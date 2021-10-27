# frozen_string_literal: true

json.array! @lockers, partial: 'lockers/locker', as: :locker
