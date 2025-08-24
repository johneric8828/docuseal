# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can %i[read create update], Template, Abilities::TemplateConditions.collection(user) do |template|
      Abilities::TemplateConditions.entity(template, user:, ability: 'manage')
    end

    can :destroy, Template, account_id: user.account_id
    can :manage, TemplateFolder, account_id: user.account_id
    can :manage, TemplateSharing, template: { account_id: user.account_id }
    can :manage, Submission, account_id: user.account_id
    can :manage, Submitter, account_id: user.account_id
    can :manage, User, account_id: user.account_id
    can :manage, EncryptedConfig, account_id: user.account_id
    can :manage, EncryptedUserConfig, user_id: user.id
    can :manage, AccountConfig, account_id: user.account_id
    can :manage, UserConfig, user_id: user.id
    can :manage, Account, id: user.account_id
    can :manage, AccessToken, user_id: user.id
    can :manage, WebhookUrl, account_id: user.account_id

    # Premium features unlocked for all users
    can :manage, :sms
    can :manage, :api
    can :manage, :countless
    can :manage, :reply_to
    can :manage, :personalization
    can :manage, :personalization_advanced
    can :manage, :tenants
    can :manage, :sms_settings
    can :manage, :api_settings
    can :manage, :webhook_settings
    can :manage, :esign_settings
    can :manage, :branding
    can :manage, :audit_trail
    can :manage, :bulk_send
    can :manage, :custom_fields
    can :manage, :analytics
    can :manage, :saml_sso
    can :read, EncryptedConfig
  end
end
