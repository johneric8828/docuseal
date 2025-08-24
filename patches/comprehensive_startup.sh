#!/bin/bash
# Comprehensive Startup Script for DocuSeal Premium Unlock
# This applies ALL modifications from the changelog

echo "🚀 Starting DocuSeal with Comprehensive Premium Unlock..."

# Apply the comprehensive premium patch
if [ -f /patches/comprehensive_premium_unlock.rb ]; then
    echo "📝 Applying comprehensive premium unlock patch..."
    ruby /patches/comprehensive_premium_unlock.rb
else
    echo "⚠️  Comprehensive patch file not found, trying simple patch..."
    if [ -f /patches/simple_premium_patch.rb ]; then
        ruby /patches/simple_premium_patch.rb
    fi
fi

# Start DocuSeal normally
echo "🔄 Starting DocuSeal application..."
exec /usr/local/bin/docker-entrypoint.sh