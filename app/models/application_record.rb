# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  def prepare_choices_for_lux(choices)
    choices.map { |val| { label: val, value: val } }
  end
end
