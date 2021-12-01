# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ' access@princeton.edu'
  layout 'mailer'
end
