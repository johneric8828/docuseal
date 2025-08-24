# API Authentication Patch for DocuSeal
# This patch modifies the API authentication to accept a hardcoded admin token

# Backup and patch api_base_controller.rb
original_file = '/app/app/controllers/api/api_base_controller.rb'
backup_file = '/app/app/controllers/api/api_base_controller.rb.backup'

# Create backup
puts "Creating backup of #{original_file}"
File.copy_stream(original_file, backup_file) unless File.exist?(backup_file)

# Read current file
content = File.read(original_file)

# Define the hardcoded admin token
admin_token = 'ADMIN_FULL_ACCESS_TOKEN_2024'

# New current_user method that checks for hardcoded token first
new_current_user_method = <<~RUBY
  def current_user
    # Check for hardcoded admin token first
    if request.headers['X-Auth-Token'] == '#{admin_token}'
      @current_user ||= User.where(role: 'admin').first || begin
        account = Account.first || Account.create!(name: 'System Account')
        User.create!(
          email: 'system.admin@docuseal.local',
          password: SecureRandom.hex(32),
          role: 'admin',
          first_name: 'System',
          last_name: 'Admin',
          account: account
        )
      end
      return @current_user
    end

    # Original authentication logic
    super || @current_user ||=
               if request.headers['X-Auth-Token'].present?
                 sha256 = Digest::SHA256.hexdigest(request.headers['X-Auth-Token'])
                 User.joins(:access_token).active.find_by(access_token: { sha256: })
               end
  end
RUBY

# Replace the current_user method
if content.match(/def current_user.*?end/m)
  content.gsub!(/def current_user.*?end/m, new_current_user_method.strip)
  
  # Write the patched file
  File.write(original_file, content)
  puts "Successfully patched #{original_file}"
  puts "Hardcoded admin token: #{admin_token}"
else
  puts "ERROR: Could not find current_user method to patch"
end