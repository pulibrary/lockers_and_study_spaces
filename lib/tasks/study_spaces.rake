# frozen_string_literal: true

namespace :study_spaces do
  desc 'Add FAKE study spaces for Firestone Library'
  task fake: :environment do
    classics_spaces = (1..10).map do |space_number|
      { location: "3-16-F-#{space_number}", general_area: 'Classics Graduate Study Room', notes: 'CLASSICS DESK' }
    end
    history_spaces = (1..10).map do |space_number|
      { location: "A-8-B-#{space_number}", general_area: 'History Graduate Study Room', notes: 'HISTORY DESK' }
    end
    study_spaces_to_add = (classics_spaces + history_spaces).reject { |study_space| StudyRoom.where(study_space).exists? }
    StudyRoom.create! study_spaces_to_add
  end
end
