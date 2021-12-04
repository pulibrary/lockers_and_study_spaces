# frozen_string_literal: true

class AddDisabledToLocker < ActiveRecord::Migration[5.2]
  def change
    add_column :lockers, :disabled, :boolean
  end
end
