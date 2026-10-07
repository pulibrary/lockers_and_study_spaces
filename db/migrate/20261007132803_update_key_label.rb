# frozen_string_literal: true

# rubocop:disable-next Layout/LineLength
class UpdateKeyLabel < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE locker_applications SET accessibility_needs = array_replace(accessibility_needs, 'Keyed entry (rather than combination)', 'Physical key entry (rather than combination)')"
  end

  def down
    execute "UPDATE locker_applications SET accessibility_needs = array_replace(accessibility_needs, 'Physical key entry (rather than combination)', 'Keyed entry (rather than combination)')"
  end
end
