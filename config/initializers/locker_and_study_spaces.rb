# frozen_string_literal: true

module LockerAndStudySpaces
  def config
    @config ||= config_yaml.with_indifferent_access
  end

  private

  def config_yaml
    raise "You are missing a configuration file: #{config_file}." unless File.exist?(config_file)

    begin
      YAML.safe_load(read_config_file, aliases: true)[Rails.env]
    rescue StandardError => e
      raise("#{config_file} was found, but could not be parsed.\n#{e.inspect}")
    end
  end

  def config_file
    Rails.root.join('config/locker_and_study_spaces.yml')
  end

  def read_config_file
    ERB.new(File.read(config_file)).result(binding)
  rescue StandardError, SyntaxError => e
    raise("#{config_file} was found, but could not be parsed with ERB. \n#{e.inspect}")
  end

  module_function :config, :config_yaml, :config_file, :read_config_file
end
