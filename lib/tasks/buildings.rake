# frozen_string_literal: true

namespace :buildings do
  desc 'Add the library buildings and associate all users and lockers with the default building'
  task seed: :environment do
    Building.seed
  end
end
