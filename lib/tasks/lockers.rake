# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :lockers do
  namespace :lewis do
    desc 'Add lockers for the Lewis Library'
    task seed: :environment do
      lewis = Building.find_or_create_by name: 'Lewis Library'
      floors = [3, 4]
      lockers = floors.flat_map do |floor|
        (1..52).map do |locker_number|
          { location: ((floor * 100) + locker_number).to_s, general_area: "#{floor.ordinalize} floor", building: lewis, size: 2,
            floor: "#{floor.ordinalize} floor" }
        end
      end
      lockers_to_add = lockers.reject { |locker| Locker.where(locker).exists? }
      Locker.create! lockers_to_add
    end
  end

  namespace :firestone do
    desc 'Add FAKE anonymized lockers for the Firestone Library - these ARE NOT actual Firestone Lockers'
    task fake: :environment do
      firestone = Building.find_or_create_by name: 'Firestone Library'
      floors = [2, 3, 4, 'A', 'B', 'C']
      lockers = floors.flat_map do |floor|
        floor_name = (floor.instance_of?(Integer) ? "#{floor.ordinalize} floor" : "#{floor} floor")
        (1..10).map do |locker_number|
          5.times.map do |count|
            { location: "#{floor}-#{count}-A-#{locker_number}", general_area: "#{floor}-#{count}-A", floor: floor_name, building: firestone, size: 4,
              combination: "#{locker_number}-#{count}", accessible: true }
          end.first
          5.times.map do |count|
            { location: "#{floor}-#{count}-A-#{locker_number}", general_area: "#{floor}-#{count}-A", floor: floor_name, building: firestone, size: 6,
              combination: "#{locker_number}-#{count}" }
          end.first
        end
      end
      lockers_to_add = lockers.reject { |locker| Locker.where(locker).exists? }
      Locker.create! lockers_to_add
    end
  end
end
# rubocop:enable Metrics/BlockLength
