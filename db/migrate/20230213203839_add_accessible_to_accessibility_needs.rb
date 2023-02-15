# frozen_string_literal: true

class AddAccessibleToAccessibilityNeeds < ActiveRecord::Migration[7.0]
  def change
    Rake::Task['locker_applications:migrate_accessible_field'].invoke
  end
end
