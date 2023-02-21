# frozen_string_literal: true

namespace :lockers do
  namespace :lewis do
    desc 'Add lockers for the Lewis Library'
    task seed: :environment do
      lewis = Building.find_or_create_by name: 'Lewis Library'
      floors = [3, 4]
      lockers = floors.flat_map do |floor|
        (1..52).map do |locker_number|
          { location: ((floor * 100) + locker_number).to_s, general_area: "#{floor.ordinalize} floor", building: lewis, size: 2 }
        end
      end
      lockers_to_add = lockers.reject { |locker| Locker.where(locker).exists? }
      Locker.create! lockers_to_add
    end
  end
end
