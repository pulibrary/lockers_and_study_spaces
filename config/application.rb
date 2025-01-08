# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require_relative 'lando_env'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LockerAndStudySpaces
  class Application < Rails::Application
    config.flipflop.dashboard_access_filter = -> { head :forbidden unless current_user.admin? }

    # By default, when set to `nil`, strategy loading errors are suppressed in test
    # mode. Set to `true` to always raise errors, or `false` to always warn.
    config.flipflop.raise_strategy_errors = nil

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
