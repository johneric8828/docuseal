# frozen_string_literal: true

class SmsSettingsController < ApplicationController
  before_action :load_encrypted_config
  authorize_resource :encrypted_config, only: :index
  authorize_resource :encrypted_config, parent: false, except: :index

  def index; end

  def create
    @encrypted_config.value = encrypted_config_params[:value]

    if @encrypted_config.save
      redirect_to settings_sms_path, notice: 'SMS settings saved successfully'
    else
      render :index
    end
  end

  private

  def load_encrypted_config
    @encrypted_config =
      EncryptedConfig.find_or_initialize_by(account: current_account, key: 'sms_configs')
  end

  def encrypted_config_params
    params.require(:encrypted_config).permit(value: %i[account_sid auth_token from_number messaging_service_sid])
  end
end
