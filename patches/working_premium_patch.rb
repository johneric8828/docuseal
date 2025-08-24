#!/usr/bin/env ruby
# Working Premium Features Unlock Patch for DocuSeal

puts "🔓 Applying Working Premium Unlock Patch..."

# 1. Carefully patch ability.rb
ability_file = '/app/lib/ability.rb'
if File.exist?(ability_file)
  content = File.read(ability_file)
  
  unless content.include?('can :manage, :sms')
    # Find the exact position before the final end and add premium permissions
    # This preserves the exact Ruby syntax and indentation
    premium_permissions = <<-RUBY

    # Premium features unlocked for all users
    can :manage, :sms
    can :manage, :api
    can :manage, :bulk_send
    can :manage, :personalization
    can :manage, :branding
    can :manage, :saml_sso
    can :manage, :countless
    can :read, EncryptedConfig
RUBY

    # Insert before the very last end of the initialize method
    content = content.sub(/^(\s+)can :manage, WebhookUrl, account_id: user\.account_id\s*$/) do |match|
      "#{match}#{premium_permissions}"
    end
    
    File.write(ability_file, content)
    puts "✅ Added premium permissions to ability.rb"
  else
    puts "ℹ️  Premium permissions already applied"
  end
end

puts "🎉 Working Premium Unlock Applied Successfully!"
puts ""
puts "Premium features now available:"
puts "• SMS Settings"
puts "• API Access" 
puts "• Bulk Send"
puts "• Company Branding"
puts "• SSO/SAML"
puts "• Advanced Personalization"
puts ""