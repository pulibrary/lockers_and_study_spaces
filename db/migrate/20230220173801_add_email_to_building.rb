# frozen_string_literal: true

class AddEmailToBuilding < ActiveRecord::Migration[7.0]
  def change
    add_column :buildings, :email, :string
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
