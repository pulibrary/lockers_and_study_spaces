# frozen_string_literal: true

class AddAccessibilityNeedsToLockerApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :locker_applications, :accessibility_needs, :text, array: true, default: []
  end
end
