# frozen_string_literal: true

class CreateScheduledMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :scheduled_messages do |t|
      t.date :schedule
      t.daterange :applicable_range
      t.string :template
      t.string :user_filter
      t.string :type
      t.json :results

      t.timestamps
    end
  end
end
