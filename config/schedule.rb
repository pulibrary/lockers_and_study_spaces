# frozen_string_literal: true

set :output, '/opt/lockers_and_study_spaces/shared/tmp/cron_log.log'
env :PATH, ENV.fetch('PATH', nil)

every 1.day, at: '6:00 am' do
  rake 'email:scheduled:send'
end
