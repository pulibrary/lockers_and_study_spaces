# frozen_string_literal: true

class ChangeLockerFloorTypeToString < ActiveRecord::Migration[5.2]
  def change
    change_column :lockers, :floor, :string
  end
end
