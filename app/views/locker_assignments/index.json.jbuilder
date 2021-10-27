# frozen_string_literal: true

json.array! @locker_assignments, partial: 'locker_assignments/locker_assignment', as: :locker_assignment
