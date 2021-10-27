# frozen_string_literal: true

class User < ApplicationRecord
  devise :rememberable, :omniauthable, omniauth_providers: %i[cas]

  def self.from_cas(access_token)
    user = User.find_by(provider: access_token.provider, uid: access_token.uid)
    user = User.create(provider: access_token.provider, uid: access_token.uid, admin: false) if user.blank?
    user
  end
end
