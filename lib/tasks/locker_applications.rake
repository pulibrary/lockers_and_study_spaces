# frozen_string_literal: true

namespace :locker_applications do
  desc 'Mark existing Locker Applications complete'
  task mark_applications_complete: :environment do
    LockerApplication.mark_applications_complete
  end
end
