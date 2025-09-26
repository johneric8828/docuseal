# frozen_string_literal: true

module Sms
  module_function

  def configured?(account)
    config = configuration_for(account)

    return false unless config.is_a?(Hash)

    config['account_sid'].present? &&
      config['auth_token'].present? &&
      (config['from_number'].present? || config['messaging_service_sid'].present?)
  end

  def configuration_for(account)
    account.encrypted_configs.find_by(key: EncryptedConfig::SMS_CONFIGS_KEY)&.value.presence
  end
end
