# frozen_string_literal: true

class AddBuildingIdToScheduledMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_messages, :building_id, :bigint, default: 1
    add_index :scheduled_messages, :building_id
  end
end
