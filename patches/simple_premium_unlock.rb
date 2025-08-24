#!/usr/bin/env ruby
# Simple Premium Features Unlock Patch for DocuSeal

puts "🔓 Applying Simple Premium Unlock Patch..."

# 1. Patch ability.rb - Just add premium permissions at the end
ability_file = '/app/lib/ability.rb'
if File.exist?(ability_file)
  content = File.read(ability_file)
  
  unless content.include?('can :manage, :sms')
    # Simply append premium permissions before the final end
    premium_block = <<~RUBY

    # Premium features unlocked
    can :manage, :sms
    can :manage, :api  
    can :manage, :bulk_send
    can :manage, :personalization
    can :manage, :branding
    can :manage, :saml_sso
    can :manage, :countless
    can :read, EncryptedConfig
    RUBY
    
    content = content.sub(/(\s*)end\s*\z/, "#{premium_block}\\1end")
    File.write(ability_file, content)
    puts "✅ Added premium permissions to ability.rb"
  end
end

# 2. Patch routes.rb - Remove multitenant restrictions
routes_file = '/app/config/routes.rb'
if File.exist?(routes_file)
  content = File.read(routes_file)
  
  # Replace multitenant checks with 'true' to always enable routes
  content = content.gsub('unless Docuseal.multitenant?', 'if false  # Premium unlocked')
  File.write(routes_file, content)
  puts "✅ Enabled premium routes"
end

puts "🎉 Simple Premium Unlock applied! Restart to see changes."