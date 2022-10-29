# frozen_string_literal: true

class Building < ApplicationRecord
  validates :name, uniqueness: true

  def self.building_choices
    placeholder = { label: 'Select Library', value: 'placeholder', disabled: true }
    choices = [placeholder]
    choices.concat(Building.all.map { |building| { label: building.name, value: building.id } })
  end

  def self.seed
    Building.new(name: 'Firestone Library').save
    Building.new(name: 'Lewis Library').save
    firestone = Building.find_by(name: 'Firestone Library')
    Locker.where(building_id: nil).find_each { |locker| locker.update(building_id: firestone.id) }
    User.where(admin: true, building_id: nil).find_each { |user| user.update(building_id: firestone.id) }
  end

  def self.seed_applications
    firestone = Building.find_by(name: 'Firestone Library')
    LockerApplication.where(building: nil).find_each { |locker_application| locker_application.update(building: firestone) }
  end
end
