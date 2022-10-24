# frozen_string_literal: true

class AddIndexToBuildingName < ActiveRecord::Migration[6.1]
  def change
    add_index :buildings, :name, unique: true
  end
end
