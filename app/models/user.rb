# frozen_string_literal: true

class User < ApplicationRecord
  devise :rememberable, :omniauthable, omniauth_providers: %i[cas]

  belongs_to :building, optional: true
  has_many :locker_violations
  has_many :study_room_violations
  attr_writer :applicant

  delegate :email, :name, :department, :status, :junior?, to: :applicant

  def number_of_violations
    locker_violations.count + study_room_violations.count
  end

  def self.from_cas(access_token)
    user = User.find_by(uid: access_token.uid)
    user = User.create(provider: access_token.provider, uid: access_token.uid, admin: false) if user.blank?
    user
  end

  def self.from_uid(uid)
    user = User.find_by(uid:)
    user = User.create(provider: 'cas', uid:, admin: false) if user.blank?
    user
  end

  def self.from_email(email)
    attributes = Ldap.find_by_email(email)
    if attributes.empty?
      user = User.find_by(uid: email.downcase)
      user = User.create(provider: 'migration', uid: email) if user.blank?
    else
      user = User.find_by(provider: 'cas', uid: attributes[:netid])
      user = User.create(provider: 'cas', uid: attributes[:netid], admin: false) if user.blank?
    end
    user
  end

  def applicant
    @applicant ||= Applicant.new(self)
  end

  def to_s
    uid
  end

  def works_at_enabled_building?
    case building&.name
    when 'Firestone Library'
      true
    when 'Lewis Library'
      Flipflop.lewis_staff?
    else
      false
    end
  end
end
