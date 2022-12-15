# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def cas
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_cas(request.env['omniauth.auth'])

      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      if is_navigational_format?
        set_flash_message(:success, :success, kind: 'from Princeton Central Authentication ' \
                                                    'Service')
      end
    end
  end
end
