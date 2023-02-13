# frozen_string_literal: true

namespace :locker_applications do
  desc 'Mark existing Locker Applications complete'
  task mark_applications_complete: :environment do
    LockerApplication.mark_applications_complete
  end

  desc 'Migrate accessible field to accessibility_needs field'
  task migrate_accessible_field: :environment do
    LockerApplication.migrate_accessible_field
  end
end
