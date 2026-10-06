# frozen_string_literal: true

# This class is responsible for determining which locker sizes are available
# for the specified user in a given building
class LockerSizeChoices
  def initialize(config: LockerAndStudySpaces.config.fetch(:locker_sizes, []))
    @config = config
  end

  def call(user:, building_name:, config: LockerAndStudySpaces.config.fetch(:locker_sizes, []))
    choices = config[building_name]
    if user.blank? || user.junior? || user.sophomore? || user.first_year?
      [choices.first]
    else
      choices
    end
  end

  private

  attr_reader :config
end
