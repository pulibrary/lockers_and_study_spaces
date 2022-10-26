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
        when :status_at_application, 'status_at_application', :department_at_application, 'department_at_application'
          memo.search_by_relation(relation: :locker_application, field: field, value: val)
        when :general_area, 'general_area', :floor, 'floor'
          memo.search_by_relation(relation: :locker, field: field, value: val)
        when :expiration_date_start, 'expiration_date_start', :expiration_date_end, 'expiration_date_end', :active, 'active'
          memo.search_by_date(field: field.to_sym, value: val)
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

    def search_by_date(field:, value:)
      value = DateTime.tomorrow.to_date if field == :active
      if %i[expiration_date_start active].include?(field)
        where('expiration_date >= ?', value)
      else
        where('expiration_date <= ?', value)
      end
    end
  end

  def locker_choices(building:)
    available = Locker.available_lockers(building: building).pluck(:id, :location, :size)
    prepare_locker_choices_for_lux(available)
  end

  def preferred_locker_choices(building:)
    available = if locker_application.blank?
                  []
                else
                  locker_application.available_lockers_in_area_and_size(building: building)
                                    .pluck(:id, :location, :size)
                end
    prepare_locker_choices_for_lux(available)
  end

  def release
    self.released_date = DateTime.now.to_date
    self.expiration_date = DateTime.now.to_date
    save!
  end

  def not_a_senior_or_faculty
    user.status != 'senior' && user.status != 'faculty'
  end

  private

  def prepare_locker_choices_for_lux(choices)
    choices.unshift [locker.id, locker.location, locker.size] if locker.present?
    choices.map { |locker| { label: "#{locker[1]} (#{locker[2]}')", value: locker[0] } }
  end
end
