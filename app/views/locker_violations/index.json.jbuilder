# frozen_string_literal: true

json.array! @locker_violations, partial: 'violations/violation', as: :violation
