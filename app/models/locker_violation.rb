# frozen_string_literal: true

class LockerViolation < ApplicationRecord
  belongs_to :locker
  belongs_to :user

  delegate :location, to: :locker
  delegate :email, :name, :number_of_violations, to: :user

  def current_user
    @current_user ||= locker.current_assignment&.user
    @user = @current_user
    @current_user
  end
end
