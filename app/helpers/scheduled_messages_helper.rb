# frozen_string_literal: true

module ScheduledMessagesHelper
  def daterange_to_string(daterange)
    first = daterange.to_a.first
    last = daterange.to_a.last
    "#{first.strftime('%m/%d/%Y')} - #{last.strftime('%m/%d/%Y')}"
  end
end
