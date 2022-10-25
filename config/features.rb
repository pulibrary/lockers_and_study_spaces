# frozen_string_literal: true

Flipflop.configure do
  # Strategies will be used in the order listed here.
  strategy :cookie
  strategy :active_record
  strategy :default

  group :lewis_library do
    feature :lewis_staff, title: 'Staff features', description: 'Allow Lewis staff members to administer Lewis lockers and applications', default: false
    feature :lewis_patrons, title: 'Patron features', description: 'Allow Lewis patrons to submit locker applications', default: false
  end
end
