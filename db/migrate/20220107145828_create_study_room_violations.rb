# frozen_string_literal: true

class CreateStudyRoomViolations < ActiveRecord::Migration[5.2]
  def change
    create_table :study_room_violations do |t|
      t.integer :user_id
      t.integer :study_room_id
      t.integer :number_of_books

      t.timestamps
    end
  end
end
