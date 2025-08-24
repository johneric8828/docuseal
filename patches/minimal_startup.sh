#!/bin/sh

echo "🚀 Starting DocuSeal with Premium Features..."

# Apply final premium patch only
if [ -f /patches/final_premium_unlock.rb ]; then
  echo "🔓 Applying Final Premium Unlock..."
  cd /app && ruby /patches/final_premium_unlock.rb
fi

# Start DocuSeal with original command
echo "🚀 Starting DocuSeal..."
cd /app
exec /app/bin/bundle exec puma -C /app/config/puma.rb --dir /app