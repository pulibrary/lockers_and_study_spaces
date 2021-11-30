# frozen_string_literal: true

class CreateLockerViolations < ActiveRecord::Migration[5.2]
  def change
    create_table :locker_violations do |t|
      t.integer :locker_id
      t.integer :user_id
      t.integer :number_of_books

      t.timestamps
    end
  end
end
