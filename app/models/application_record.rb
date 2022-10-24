# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(term:, field: 'uid')
    return all if term.blank?

    where("#{field} ilike ?", "%#{term}%")
  end

  protected

  def prepare_choices_for_lux(choices)
    choices.map { |val| { label: val, value: val } }
  end

  def prepare_size_choices_for_lux(choices)
    choices.map { |val| { label: "#{val}-foot", value: val } }
  end

  def prepare_semester_choices_for_lux(choices)
    choices.map do |val|
      Rails.logger.debug val
      label = val == 'Fall' ? 'Fall & Spring' : 'Spring Only'
      { label: label, value: val }
    end
  end
end
