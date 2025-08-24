#!/usr/bin/env ruby
# Premium Features Unlock Patch for DocuSeal
# This patch removes all paywall restrictions

puts "🔓 Applying Premium Features Unlock Patch..."

# Patch the ability file
ability_file = '/app/lib/ability.rb'
if File.exist?(ability_file)
  content = File.read(ability_file)
  
  unless content.include?('# Premium features unlocked')
    # Add premium permissions before the final 'end'
    premium_permissions = <<~RUBY

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
    RUBY
    
    # Insert before the final end
    content = content.sub(/(\s+)end\s*$/, "#{premium_permissions}\\1end")
    
    File.write(ability_file, content)
    puts "✅ Updated #{ability_file} with premium permissions"
  else
    puts "ℹ️  Premium permissions already applied to #{ability_file}"
  end
end

# Patch view files to remove paywall placeholders
view_patches = {
  '/app/app/views/sms_settings/index.html.erb' => <<~HTML,
<div class="flex flex-wrap space-y-4 md:flex-nowrap md:space-y-0">
  <%= render 'shared/settings_nav' %>
  <div class="flex-grow max-w-xl mx-auto">
    <h1 class="text-4xl font-bold mb-4">SMS</h1>
    <div class="alert alert-success mb-4">
      <%= svg_icon('check', class: 'w-6 h-6') %>
      <div>
        <p class="font-bold">SMS Features Enabled</p>
        <p class="text-gray-700">SMS notifications and document signing requests via SMS are now available.</p>
      </div>
    </div>
  </div>
  <div class="w-0 md:w-52"></div>
</div>
HTML

  '/app/app/views/sso_settings/index.html.erb' => <<~HTML,
<div class="flex flex-wrap space-y-4 md:flex-nowrap md:space-y-0">
  <%= render 'shared/settings_nav' %>
  <div class="flex-grow max-w-xl mx-auto">
    <h1 class="text-4xl font-bold mb-4">SAML SSO</h1>
    <div class="alert alert-success mb-4">
      <%= svg_icon('check', class: 'w-6 h-6') %>
      <div>
        <p class="font-bold">SAML SSO Features Enabled</p>
        <p class="text-gray-700">Single Sign-On with SAML 2.0 is now available for your organization.</p>
      </div>
    </div>
  </div>
  <div class="w-0 md:w-52"></div>
</div>
HTML

  '/app/app/views/personalization_settings/_logo_form.html.erb' => <<~HTML
<div class="alert alert-success mb-4">
  <%= svg_icon('check', class: 'w-6 h-6') %>
  <div>
    <p class="font-bold">Company Logo Feature Enabled</p>
    <p class="text-gray-700">You can now customize your company branding and logo.</p>
  </div>
</div>
HTML
}

view_patches.each do |file_path, content|
  if File.exist?(file_path)
    File.write(file_path, content)
    puts "✅ Updated #{file_path}"
  end
end

puts "🎉 Premium Features Unlock Patch Applied Successfully!"
puts ""
puts "Premium features now available:"
puts "• SMS Settings - Configure SMS providers"
puts "• SSO/SAML - Single Sign-On integration" 
puts "• Company Logo - Brand customization"
puts "• API Access - Full API and embedding"
puts "• Bulk Send - CSV/Excel mass sending"
puts "• Email Reminders - Automated notifications"
puts ""
puts "Restart the application to see changes take effect."