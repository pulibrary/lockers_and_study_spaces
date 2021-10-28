# frozen_string_literal: true

class LockerApplication < ApplicationRecord
  belongs_to :user

  def initialize(*args)
    super
    return unless user.present?
    self.department_at_application ||= applicant.department
    self.status_at_application ||= applicant.status
  end

  def applicant
    return nil unless user.present?
    @applicant ||= Applicant.new(user)
  end

  def size_choices
    choices = LockerAndStudySpaces.config.fetch(:locker_sizes,[])
    return [choices.first] if user.blank? || applicant.junior?
    choices
  end
end
