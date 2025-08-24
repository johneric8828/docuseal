#!/bin/bash
# Simple startup script that applies premium patch and starts DocuSeal

echo "🚀 Starting DocuSeal with Premium Unlock..."

# Apply the simple premium patch
if [ -f /patches/simple_premium_patch.rb ]; then
    echo "📝 Applying premium unlock patch..."
    ruby /patches/simple_premium_patch.rb
fi

# Start DocuSeal normally
echo "🔄 Starting DocuSeal application..."
exec /usr/local/bin/docker-entrypoint.sh