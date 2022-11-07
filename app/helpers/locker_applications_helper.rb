# frozen_string_literal: true

module LockerApplicationsHelper
  def toggle_link_text(archived)
    archived ? 'Unarchive' : 'Archive'
  end

  def archive_display_text(archived)
    archived ? 'Hide Archived Applications' : 'Show Archived Applications'
  end
end
