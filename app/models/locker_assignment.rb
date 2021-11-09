# frozen_string_literal: true

class LockerAssignment < ApplicationRecord
  belongs_to :locker
  belongs_to :locker_application

  validates :start_date, presence: true

  def locker_choices
    available = Locker.available_lockers.pluck(:id, :location)
    prepare_locker_choices_for_lux(available)
  end

  def preferred_locker_choices
    available = if locker_application.blank?
                  []
                else
                  locker_application.available_lockers_in_area.pluck(:id, :location)
                end
    prepare_locker_choices_for_lux(available)
  end

  def netid
    locker_application.user.uid
  end

  private

  def prepare_locker_choices_for_lux(choices)
    choices.unshift [locker.id, locker.location] if locker.present?
    choices.map { |locker| { label: locker[1], value: locker[0] } }
  end
end
