# frozen_string_literal: true

class CreateLockers < ActiveRecord::Migration[5.2]
  def change
    create_table :lockers do |t|
      t.string :location
      t.integer :size
      t.string :general_area
      t.boolean :accessible
      t.string :notes
      t.string :combination
      t.string :code
      t.string :tag
      t.string :discs
      t.string :clutch
      t.string :hubpos
      t.string :key_number
      t.integer :floor

      t.timestamps
    end
  end
end
