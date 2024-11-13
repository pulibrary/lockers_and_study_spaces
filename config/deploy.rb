# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.0'

set :application, 'lockers_and_study_spaces'
set :repo_url, 'https://github.com/pulibrary/locker_and_study_spaces.git'

# Default branch is :main
set :branch, ENV.fetch('BRANCH', 'main')

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/lockers_and_study_spaces'

# Install yarn devDependencies, not just the prod ones
set :yarn_flags, '--silent --no-progress'

set :assets_manifests, ['app/assets/config/manifest.js']

set :whenever_roles, -> { %i[cron_prod1 cron_prod2] }

namespace :application do
  # You can/ should apply this command to a single host
  # cap --hosts=pulfalight-staging1.princeton.edu staging application:remove_from_nginx
  desc 'Marks the server(s) to be removed from the loadbalancer'
  task :remove_from_nginx do
    count = 0
    on roles(:app) do
      count += 1
    end
    raise 'You must run this command on no more than half the servers utilizing the --hosts= switch' if count > (roles(:app).length / 2)

    on roles(:app) do
      within release_path do
        execute :touch, 'public/remove-from-nginx'
      end
    end
  end

  # You can/ should apply this command to a single host
  # cap --hosts=pulfalight-staging1.princeton.edu staging application:serve_from_nginx
  desc 'Marks the server(s) to be added back to the loadbalancer'
  task :serve_from_nginx do
    on roles(:app) do
      within release_path do
        execute :rm, '-f public/remove-from-nginx'
      end
    end
  end
end
