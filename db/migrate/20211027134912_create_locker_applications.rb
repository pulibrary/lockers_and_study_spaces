# frozen_string_literal: true

class CreateLockerApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :locker_applications do |t|
      t.integer :preferred_size
      t.string :preferred_general_area
      t.boolean :accessible
      t.string :semester
      t.string :staus_at_application
      t.string :department_at_application
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
