# frozen_string_literal: true

json.array! @scheduled_messages, partial: 'scheduled_messages/scheduled_message', as: :scheduled_message
