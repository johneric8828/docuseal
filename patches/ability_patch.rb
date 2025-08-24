# Ability Patch for DocuSeal Premium Features
# This patch grants admin users access to all premium features

original_file = '/app/lib/ability.rb'
backup_file = '/app/lib/ability.rb.backup'

# Create backup
puts "Creating backup of #{original_file}"
File.copy_stream(original_file, backup_file) unless File.exist?(backup_file)

# Read current file
content = File.read(original_file)

# Premium features permissions to add for admin users
premium_permissions = <<~RUBY
    # Premium features for admin users
    if user.role == 'admin'
      can :manage, :sms
      can :manage, :api
      can :manage, :countless
      can :manage, :reply_to
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
      can :read, EncryptedConfig
      can :manage, EncryptedConfig
    end
RUBY

# Find the initialize method and add the premium permissions before the final end
if content.include?("def initialize(user)")
  # Find the position just before the last end in the initialize method
  lines = content.lines
  initialize_start = -1
  initialize_end = -1
  
  lines.each_with_index do |line, index|
    if line.strip == "def initialize(user)"
      initialize_start = index
    elsif initialize_start >= 0 && line.strip == "end"
      initialize_end = index
      break
    end
  end
  
  if initialize_start >= 0 && initialize_end >= 0
    # Insert premium permissions before the end
    lines.insert(initialize_end, premium_permissions)
    content = lines.join
    
    # Write the patched file
    File.write(original_file, content)
    puts "Successfully patched #{original_file}"
  else
    puts "ERROR: Could not find initialize method boundaries"
  end
else
  puts "ERROR: Could not find initialize method to patch"
end