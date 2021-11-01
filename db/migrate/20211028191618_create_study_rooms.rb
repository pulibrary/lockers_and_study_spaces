# frozen_string_literal: true

class CreateStudyRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :study_rooms do |t|
      t.string :location
      t.string :general_area
      t.string :notes

      t.timestamps
    end
  end
end
