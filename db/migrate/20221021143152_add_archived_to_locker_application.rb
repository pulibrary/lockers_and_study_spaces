# frozen_string_literal: true

class AddArchivedToLockerApplication < ActiveRecord::Migration[6.1]
  def change
    add_column :locker_applications, :archived, :boolean, default: false
  end
end
