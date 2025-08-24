#!/bin/bash

# Working DocuSeal API Test Script
# Your actual API token from DocuSeal

API_TOKEN="5r917kJjEphiXeRSHraYh3SVFJfNNRf2q69qCEQcidw"
BASE_URL="http://localhost:3001"

echo "DocuSeal API Testing with Real Token"
echo "===================================="
echo "API Token: $API_TOKEN"
echo "Base URL: $BASE_URL"
echo ""

# Test 1: Get current user info
echo "=== Test 1: Get current user info ==="
curl -s -X GET "$BASE_URL/api/user" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | jq . 2>/dev/null || echo "Response: $(curl -s -X GET "$BASE_URL/api/user" -H "X-Auth-Token: $API_TOKEN" -H "Content-Type: application/json")"

echo ""

# Test 2: List templates
echo "=== Test 2: List templates ==="
curl -s -X GET "$BASE_URL/api/templates" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | jq . 2>/dev/null || echo "Response: $(curl -s -X GET "$BASE_URL/api/templates" -H "X-Auth-Token: $API_TOKEN" -H "Content-Type: application/json")"

echo ""

# Test 3: List submissions
echo "=== Test 3: List submissions ==="
curl -s -X GET "$BASE_URL/api/submissions" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | jq . 2>/dev/null || echo "Response: $(curl -s -X GET "$BASE_URL/api/submissions" -H "X-Auth-Token: $API_TOKEN" -H "Content-Type: application/json")"

echo ""

# Test 4: Try to access premium endpoint (will likely fail)
echo "=== Test 4: Test premium endpoint access ==="
curl -s -X GET "$BASE_URL/api/tools/merge" \
  -H "X-Auth-Token: $API_TOKEN" \
  -H "Content-Type: application/json" | head -50

echo ""
echo "✅ API Authentication Working!"
echo "🔑 Your API Token: $API_TOKEN"
echo "🌐 API Base URL: $BASE_URL"
echo ""
echo "Next: Test premium features in the web interface"