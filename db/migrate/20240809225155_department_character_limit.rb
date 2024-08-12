# frozen_string_literal: true

class DepartmentCharacterLimit < ActiveRecord::Migration[7.0]
  def up
    LockerApplication.where('LENGTH(department_at_application) > 70').find_each do |application|
      application.update(department_at_application: application.department_at_application.truncate(70, separator: /\s/))
    end
    change_column :locker_applications, :department_at_application, :string, limit: 70
  end

  def down
    change_column :locker_applications, :department_at_application, :string
  end
end
