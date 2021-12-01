# frozen_string_literal: true

class LockerAssignment < ApplicationRecord
  belongs_to :locker
  belongs_to :locker_application

  delegate :location, :combination, to: :locker
  delegate :uid, :email, :name, :status_at_application, :department, :user, :applicant, to: :locker_application

  validates :start_date, :expiration_date, presence: true

  class << self
    def search(queries:)
      return all if queries.blank?

      queries.to_h.reduce(all) do |memo, (field, val)|
        case field
        when :uid, 'uid'
          memo.search_by_user(uid: val)
        when :status_at_application, 'status_at_application'
          memo.search_by_relation(relation: :locker_application, field: field, value: val)
        when :general_area, 'general_area', :floor, 'floor'
          memo.search_by_relation(relation: :locker, field: field, value: val)
        else
          memo
        end
      end
    end

    def search_by_user(uid:)
      return all if uid.blank?

      joins(:locker_application).joins('join users on locker_applications.user_id = users.id').where("users.uid = '#{uid}'")
    end

    def search_by_relation(relation:, field:, value:)
      return all if value.blank?

      joins(relation.to_sym).where("#{relation.to_s.pluralize}.#{field} = '#{value}'")
    end
  end

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

  private

  def prepare_locker_choices_for_lux(choices)
    choices.unshift [locker.id, locker.location] if locker.present?
    choices.map { |locker| { label: locker[1], value: locker[0] } }
  end
end
