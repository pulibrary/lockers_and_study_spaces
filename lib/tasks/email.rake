# frozen_string_literal: true

namespace :email do
  namespace :scheduled do
    namespace :send do
      desc 'Send Firestone messages scheduled for today'
      task firestone: :environment do
        ScheduledMessage.not_yet_sent(1)
                        .today
                        .each(&:send_emails)
      end

      desc 'Send Lewis messages scheduled for today'
      task lewis: :environment do
        ScheduledMessage.not_yet_sent(2)
                        .today
                        .each(&:send_emails)
      end
    end
  end
end
