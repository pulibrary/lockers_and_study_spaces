# frozen_string_literal: true

class ScheduledMessage < ApplicationRecord
  validates :building_id, presence: true

  scope :past, -> { where('schedule < ?', Date.today) }
  scope :today, -> { where('schedule = ?', Date.today) }
  scope :future, -> { where('schedule > ?', Date.today) }
  scope :already_sent, ->(building_id) { where.not(results: nil).where(building_id:) }
  scope :not_yet_sent, ->(building_id) { where(results: nil).where(building_id:) }

  before_save :default_values

  validates :schedule, presence: true

  def applicable_range=(value)
    if value.is_a?(String) && value.present?
      # Handle the dates that lux gives us, e.g. "5/19/2022 - 5/24/2022"
      value = daterange_string_to_daterange(value)
    end
    super(value)
  end

  def schedule=(value)
    value = Date.strptime(value, '%m/%d/%Y') if value.is_a?(String) && value.present?
    super(value)
  end

  def daterange_string_to_daterange(string)
    dates = string.split('-')
                  .map(&:strip)
                  .map { |date| Date.strptime(date, '%m/%d/%Y') }
    dates.first..dates.second
  end

  def default_values
    self.template ||= case building_id
                      when 1
                        'firestone_locker_renewal'
                      when 2
                        'lewis_locker_renewal'
                      end
    self.type ||= 'LockerRenewalMessage'
    self.user_filter ||= 'not_a_senior_or_faculty'
  end

  def send_emails
    return unless schedule == Date.today
    return unless results.nil?

    relevant_assignments(building_id).each do |assignment|
      if assignment.email.include?('@@')
        assignment.email = assignment.email.gsub('@@', '@')
        byebug
      end
      UserMailer.with(assignment:, template_name: template)
                .renewal_email
                .deliver_now
    end
    self.results = { success: relevant_assignments(building_id).map(&:email) }
    save!
  end

  # The model that is the topic of these messages; override this as needed in child classes
  def assignment_model
    LockerAssignment
  end

  private

  def relevant_assignments(building_id)
    @relevant_assignments ||= assignment_model.where(expiration_date: applicable_range)
                                              .joins(:locker)
                                              .where(locker: { building_id: })
                                              .select do |assignment|
      user_filter ? assignment.send(user_filter) : true
    end
  end
end
