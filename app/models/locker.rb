# frozen_string_literal: true

class Locker < ApplicationRecord
  validates :location, presence: true
  validates :general_area, presence: true
  validates :combination, presence: true, unless: -> { building&.name == 'Lewis Library' }

  belongs_to :building, optional: true

  def self.available_lockers(building:)
    where.not(id: LockerAssignment.where(released_date: nil).select(:locker_id))
         .where(disabled: [false, nil])
         .where(building:)
  end

  def size_choices(building: nil)
    prepare_choices_for_lux(size_list(building:))
  end

  def floor_choices(building: nil)
    prepare_choices_for_lux(floor_list(building:))
  end

  def general_area_choices
    choices = Locker.pluck(:general_area).uniq.sort
    prepare_choices_for_lux(choices)
  end

  def size_floor_list
    size_list.product(floor_list).map { |pair| pair.join("' ") }
  end

  def current_assignment
    @current_assignment ||= LockerAssignment.where(locker_id: id, released_date: nil).first
  end

  def space_totals
    @space_totals ||= self.class.where(building: firestone)
                          .group(:size)
                          .group(:floor)
                          .order(:floor)
                          .count
                          .transform_keys { |key| key.join("' ") }
  end

  def assignable_space_totals
    @assignable_space_totals ||= self.class.where(disabled: false).group(:size).group(:floor).count.transform_keys { |key| key.join("' ") }
  end

  def space_assigned_totals
    @space_assigned_totals ||= LockerAssignment.search(queries: { active: true }).joins(:locker).group(:size).group(:floor).count.transform_keys do |key|
      key.join("' ")
    end
  end

  def space_report
    space_totals.map do |key, total|
      next if assignable_space_totals[key].blank?

      assignable = assignable_space_totals[key]
      assigned = space_assigned_totals[key] || 0
      [key, [total, assignable, assigned, assignable - assigned]]
    end.compact.to_h
  end

  def floor_list(building: nil)
    firestone_floor_list = LockerAndStudySpaces.config.fetch(:firestone_locker_floors, []).keys
    lewis_floor_list = LockerAndStudySpaces.config.fetch(:lewis_locker_floors, []).keys

    @floor_list ||= if Flipflop.lewis_patrons? && building&.name == 'Lewis Library'
                      lewis_floor_list
                    else
                      firestone_floor_list
                    end
  end

  def size_list(building: nil)
    firestone_locker_sizes = LockerAndStudySpaces.config.fetch(:locker_sizes, [])['Firestone Library']
    lewis_locker_sizes = LockerAndStudySpaces.config.fetch(:locker_sizes, [])['Firestone Library']

    @size_list ||= if Flipflop.lewis_patrons? && building&.name == 'Lewis Library'
                     lewis_locker_sizes
                   else
                     firestone_locker_sizes
                   end
  end

  private

  def firestone
    Building.find_by(name: 'Firestone Library')
  end
end
