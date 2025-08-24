# Minimal Ability Patch for DocuSeal Premium Features
# This adds specific permissions for SMS, personalization, and users features

original_file = '/app/lib/ability.rb'
backup_file = '/app/lib/ability.rb.backup'

# Create backup
puts "Creating backup of #{original_file}"
File.copy_stream(original_file, backup_file) unless File.exist?(backup_file)

# Read current file
content = File.read(original_file)

# Check if patch is already applied
if content.include?('# Premium features for admin users')
  puts "Patch already applied, skipping..."
  exit 0
end

# Premium features to add
premium_patch = <<~PATCH

    # Premium features for admin users
    if user.role == "admin"
      can :manage, :sms
      can :manage, :personalization  
      can :manage, :users
      can :read, EncryptedConfig
    end
PATCH

# Add the patch before the final end
if content.include?('can :manage, WebhookUrl, account_id: user.account_id')
  content = content.gsub(
    'can :manage, WebhookUrl, account_id: user.account_id',
    "can :manage, WebhookUrl, account_id: user.account_id#{premium_patch}"
  )
  
  File.write(original_file, content)
  puts "✅ Successfully patched #{original_file} with premium features!"
else
  puts "❌ ERROR: Could not find insertion point in ability.rb"
  exit 1
end