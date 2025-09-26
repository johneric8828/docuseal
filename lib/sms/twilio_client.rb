# frozen_string_literal: true

require 'twilio-ruby'

module Sms
  class TwilioClient
    ConfigurationError = Class.new(StandardError)

    def initialize(account)
      @account = account
      @config = Sms.configuration_for(account) || {}
    end

    def configured?
      @config['account_sid'].present? &&
        @config['auth_token'].present? &&
        (@config['from_number'].present? || @config['messaging_service_sid'].present?)
    end

    def send_invitation(submitter)
      raise ConfigurationError, 'SMS configuration missing' unless configured?
      raise ConfigurationError, 'Submitter phone missing' if submitter.phone.blank?

      message_body = build_body(submitter)
      raise ConfigurationError, 'SMS body missing' if message_body.blank?

      response = client.messages.create(**message_params(submitter.phone, message_body))

      SubmissionEvent.create!(submitter:, event_type: 'send_sms', data: { provider: 'twilio', sid: response.sid })

      response
    end

    private

    def build_body(submitter)
      template = I18n.t(:submitter_invitation_sms_body_sign, locale: submitter.submission.account.locale)
      ReplaceEmailVariables.call(template, submitter:, tracking_event_type: 'click_sms')
    end

    def client
      @client ||= ::Twilio::REST::Client.new(@config['account_sid'], @config['auth_token'])
    end

    def message_params(to, body)
      params = { to:, body: }

      if @config['messaging_service_sid'].present?
        params[:messaging_service_sid] = @config['messaging_service_sid']
      else
        params[:from] = @config['from_number']
      end

      params
    end
  end
end
