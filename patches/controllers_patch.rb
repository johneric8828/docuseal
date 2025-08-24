#!/usr/bin/env ruby
# Controllers patch to handle premium features

puts "🔧 Applying Controllers Patch for Premium Features..."

# 1. Update PersonalizationSettingsController
personalization_controller = '/app/app/controllers/personalization_settings_controller.rb'
if File.exist?(personalization_controller)
  content = File.read(personalization_controller)
  
  # Add company_logo to allowed keys
  content = content.gsub(
    /(AccountConfig::FORM_COMPLETED_MESSAGE_KEY,)/,
    "\\1\n    'company_logo',"
  )
  
  File.write(personalization_controller, content)
  puts "✅ Updated PersonalizationSettingsController"
end

# 2. Create SMS Settings Controller if needed
sms_controller_content = <<~RUBY
class SmsSettingsController < ApplicationController
  before_action :load_encrypted_config

  def index
    authorize!(:manage, :sms_settings)
  end

  def create
    authorize!(:manage, :sms_settings)
    
    @encrypted_config.assign_attributes(encrypted_config_params)
    
    if @encrypted_config.save
      redirect_to settings_sms_path, notice: 'SMS settings updated successfully'
    else
      render :index
    end
  end

  private

  def load_encrypted_config
    @encrypted_config = current_account.encrypted_configs.find_or_initialize_by(key: 'sms_settings')
  end

  def encrypted_config_params
    params.require(:encrypted_config).permit(:provider, :account_sid, :auth_token, :from_number)
           .transform_values(&:presence)
           .compact
           .then { |attrs| { key: 'sms_settings', value: attrs } }
  end
end
RUBY

File.write('/app/app/controllers/sms_settings_controller.rb', sms_controller_content)
puts "✅ Created SMS Settings Controller"

# 3. Create SSO Settings Controller if needed  
sso_controller_content = <<~RUBY
class SsoSettingsController < ApplicationController
  before_action :load_encrypted_config

  def index
    authorize!(:manage, :saml_sso)
  end

  def create
    authorize!(:manage, :saml_sso)
    
    @encrypted_config.assign_attributes(encrypted_config_params)
    
    if @encrypted_config.save
      redirect_to settings_sso_path, notice: 'SSO settings updated successfully'
    else
      render :index
    end
  end

  private

  def load_encrypted_config
    @encrypted_config = current_account.encrypted_configs.find_or_initialize_by(key: 'saml_configs')
  end

  def encrypted_config_params
    params.require(:encrypted_config).permit(:sso_url, :issuer, :certificate, :enforce_sso)
           .transform_values(&:presence)
           .compact
           .then { |attrs| { key: 'saml_configs', value: attrs } }
  end
end
RUBY

File.write('/app/app/controllers/sso_settings_controller.rb', sso_controller_content)
puts "✅ Created SSO Settings Controller"

puts "🎉 Controllers patch applied successfully!"