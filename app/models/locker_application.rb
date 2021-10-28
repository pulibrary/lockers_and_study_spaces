# frozen_string_literal: true

class LockerApplication < ApplicationRecord
  belongs_to :user

  def applicant
    user&.uid
  end
end
