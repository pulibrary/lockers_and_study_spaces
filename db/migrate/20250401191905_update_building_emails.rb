# frozen_string_literal: true

class UpdateBuildingEmails < ActiveRecord::Migration[7.2]
  def change
    Building.find_each do |building|
      building.email =
        case building.name
        when 'Firestone Library'
          'access@princeton.edu'
        when 'Lewis Library'
          'lewislib@princeton.edu'
        end
      building.save
    end
  end
end
