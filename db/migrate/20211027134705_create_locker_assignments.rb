# frozen_string_literal: true

class CreateLockerAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :locker_assignments do |t|
      t.date :start_date
      t.date :end_date
      t.belongs_to :locker_application
      t.belongs_to :locker, foreign_key: true

      t.timestamps
    end
  end
end
