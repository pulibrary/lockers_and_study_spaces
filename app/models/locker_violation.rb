# frozen_string_literal: true

class LockerViolation < ApplicationRecord
  belongs_to :locker
  belongs_to :user

  delegate :location, to: :locker
  delegate :number_of_violations, to: :user
  delegate :email, :name, to: :applicant

  def current_user
    @current_user ||= locker.current_assignment&.user
    @user = @current_user
    @current_user
  end

  private

  def applicant
    @applicant ||= locker.current_assignment.applicant
  end
end
