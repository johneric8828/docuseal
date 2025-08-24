#!/usr/bin/env ruby
# Simple Premium Unlock - One Line Fix
# This patches the core multitenant? method to always return true

puts "🔓 Applying Simple Premium Unlock (One-Line Fix)..."

docuseal_file = '/app/lib/docuseal.rb'

if File.exist?(docuseal_file)
  content = File.read(docuseal_file)
  
  # Replace the multitenant? method to always return true
  original_method = /def multitenant\?\s+ENV\['MULTITENANT'\] == 'true' \|\| ENV\['UNLOCK_PREMIUM'\] == 'true'\s+end/m
  
  if content.match?(original_method)
    new_content = content.gsub(original_method, <<~RUBY.strip)
      def multitenant?
        true  # Always enable premium features
      end
    RUBY
    
    File.write(docuseal_file, new_content)
    puts "✅ Patched multitenant? method to always return true"
  else
    # Fallback - try to find and replace just the return statement
    if content.include?("ENV['MULTITENANT'] == 'true' || ENV['UNLOCK_PREMIUM'] == 'true'")
      new_content = content.gsub(
        "ENV['MULTITENANT'] == 'true' || ENV['UNLOCK_PREMIUM'] == 'true'",
        "true  # Always enable premium features"
      )
      File.write(docuseal_file, new_content)
      puts "✅ Patched multitenant? method return value to true"
    else
      puts "❌ Could not find multitenant? method to patch"
    end
  end
else
  puts "❌ DocuSeal lib file not found at #{docuseal_file}"
end

puts "🎉 Simple Premium Unlock Complete! Restart container to see changes."