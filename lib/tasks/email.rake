# frozen_string_literal: true

namespace :email do
  namespace :scheduled do
    desc 'Send messages scheduled for today'
    task send: :environment do
      ScheduledMessage.not_yet_sent
                      .today
                      .each(&:send_emails)
    end
  end
end
