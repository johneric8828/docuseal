#!/bin/bash

# Test script for DocuSeal API with hardcoded admin token

API_TOKEN="ADMIN_FULL_ACCESS_TOKEN_2024"
BASE_URL="http://localhost:3001"

echo "Testing DocuSeal API with hardcoded admin token..."
echo "Token: $API_TOKEN"
echo "Base URL: $BASE_URL"
echo ""

# Test 1: Get current user info
echo "=== Test 1: Get current user info ==="
curl -s -X GET "$BASE_URL/api/users" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | jq .

echo ""

# Test 2: List templates
echo "=== Test 2: List templates ==="
curl -s -X GET "$BASE_URL/api/templates" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | jq .

echo ""

# Test 3: Test SMS endpoint access (premium feature)
echo "=== Test 3: Test SMS settings access ==="
curl -s -X GET "$BASE_URL/api/encrypted_configs" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | jq .

echo ""

# Test 4: Check API settings access
echo "=== Test 4: Check API settings access ==="
curl -s -X GET "$BASE_URL/api/access_tokens" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | jq .

echo ""
echo "API tests completed. If you see JSON responses above, the authentication is working!"
echo "If you see 401 Unauthorized errors, the patches need to be applied or the container restarted."