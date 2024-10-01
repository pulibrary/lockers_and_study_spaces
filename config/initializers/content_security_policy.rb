# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.script_src :self, :https, :unsafe_eval
  policy.object_src :none
  policy.base_uri :none
  policy.frame_ancestors :none
  policy.style_src :self, :unsafe_inline
end
