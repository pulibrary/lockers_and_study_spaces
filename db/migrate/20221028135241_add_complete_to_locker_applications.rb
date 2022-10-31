# frozen_string_literal: true

class AddCompleteToLockerApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :locker_applications, :complete, :boolean, default: false
    Rake::Task['locker_applications:mark_applications_complete'].invoke
  end
end
