# frozen_string_literal: true

class CreateStudyRoomAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :study_room_assignments do |t|
      t.date :start_date
      t.date :expiration_date
      t.date :released_date
      t.string :notes
      t.belongs_to :user, foreign_key: true
      t.belongs_to :study_room, foreign_key: true

      t.timestamps
    end
  end
end
