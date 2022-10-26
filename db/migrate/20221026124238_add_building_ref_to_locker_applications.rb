# frozen_string_literal: true

class AddBuildingRefToLockerApplications < ActiveRecord::Migration[6.1]
  def change
    add_reference :locker_applications, :building, null: true, foreign_key: true
    Rake::Task['buildings:seed_applications'].invoke
  end
end
