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

  def prepare_size_choices_for_lux(choices, building_name)
    case building_name
    when 'Firestone Library'
      choices.map { |val| { label: "#{val}-foot", value: val } }
    when 'Lewis Library'
      choices.map { |val| { label: '25" x 12"', value: val } }
    end
  end

  def prepare_semester_choices_for_lux(choices)
    choices.map do |val|
      label = val == 'Fall' ? 'Fall & Spring' : 'Spring Only'
      { label:, value: val }
    end
  end
end
