# frozen_string_literal: true

class DepartmentNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :locker_applications, :department_at_application, false, '<Unknown department>'
  end
end
