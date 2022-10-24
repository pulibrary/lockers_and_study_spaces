Flipflop.configure do
  # Strategies will be used in the order listed here.
  strategy :cookie
  strategy :active_record
  strategy :default

  group :lewis_library do
    feature :staff, title: 'Staff features', description: 'Allow Lewis staff members to administer Lewis lockers and applications'
    feature :patrons, title: 'Patron features', description: 'Allow Lewis patrons to submit locker applications'
  end

end
