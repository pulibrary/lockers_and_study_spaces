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
    @applicant ||= Applicant.new(user)
  end
end
