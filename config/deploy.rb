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
