require 'sms/twilio_client'

# frozen_string_literal: true

class SendSubmitterInvitationSmsJob
  include Sidekiq::Job

  sidekiq_options queue: :default

  def perform(params = {})
    submitter = Submitter.find_by(id: params['submitter_id'])

    return unless submitter
    return if submitter.completed_at?
    return if submitter.phone.blank?

    client = Sms::TwilioClient.new(submitter.account)

    begin
      Rails.logger.info("[SMS] Sending invitation to submitter ##{submitter.id}")
      response = client.send_invitation(submitter)
      submitter.update!(sent_at: Time.current) unless submitter.sent_at?
      Rails.logger.info("[SMS] Invitation sent for submitter ##{submitter.id} (sid=#{response.sid})")
    rescue Sms::TwilioClient::ConfigurationError => e
      Rails.logger.warn("[SMS] Configuration error for submitter ##{submitter.id}: #{e.message}")
      SubmissionEvent.create!(submitter:, event_type: :send_sms_failed,
                              data: { provider: 'twilio', error: e.message })
      Rollbar.warning(e.message) if defined?(Rollbar)
    rescue Twilio::REST::TwilioError => e
      Rails.logger.error("[SMS] Twilio API error for submitter ##{submitter.id}: #{e.message}")
      SubmissionEvent.create!(submitter:, event_type: :send_sms_failed,
                              data: { provider: 'twilio', error: e.message })
      Rollbar.error(e) if defined?(Rollbar)
      raise
    rescue StandardError => e
      Rails.logger.error("[SMS] Unexpected error for submitter ##{submitter.id}: #{e.class}: #{e.message}")
      SubmissionEvent.create!(submitter:, event_type: :send_sms_failed,
                              data: { provider: 'twilio', error: e.message })
      Rollbar.error(e) if defined?(Rollbar)
      raise
    end
  end
end
