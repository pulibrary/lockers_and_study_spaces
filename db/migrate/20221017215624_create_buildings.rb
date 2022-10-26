# frozen_string_literal: true

class CreateBuildings < ActiveRecord::Migration[6.1]
  def up
    create_table :buildings do |t|
      t.string :name, index: { unique: true }
      t.timestamps
    end
    add_column :users, :building_id, :bigint, null: true
    add_column :lockers, :building_id, :bigint, null: true
    Rake::Task['buildings:seed'].invoke
  end

  def down
    drop_table :buildings
    remove_column :users, :building_id
    remove_column :lockers, :building_id
  end
end
