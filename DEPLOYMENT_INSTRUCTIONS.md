# DocuSeal Premium Features Unlock - Deployment Instructions

This setup automatically patches DocuSeal to enable all premium features for admin users and provides a hardcoded API token for full access.

## Features Enabled
- SMS notifications and settings
- API settings and access
- Webhook configurations
- E-signature settings
- Branding options
- Audit trails
- Bulk sending
- Custom fields
- Analytics
- All encrypted configurations

## Hardcoded Admin Token
**Token:** `ADMIN_FULL_ACCESS_TOKEN_2024`

This token provides full admin access to all API endpoints and premium features.

## Deployment Steps

### 1. Upload to Portainer
1. Copy the entire `docuseal-master` folder to your server
2. In Portainer, create a new stack
3. Use "Upload" option and select the `docker-compose.yml` file
4. Set the `HOST` environment variable (e.g., `docuseal.yourdomain.com`)
5. Deploy the stack

### 2. File Structure
Your deployment should have this structure:
```
docuseal-master/
├── docker-compose.yml
├── patches/
│   ├── api_auth_patch.rb
│   └── ability_patch.rb
├── test_api_access.sh
├── docuseal/ (created by Docker)
└── pg_data/ (created by Docker)
```

### 3. How the Patching Works
- When the container starts, it automatically applies patches from the `patches/` directory
- Patches modify the application code to enable premium features
- Changes survive container restarts but are reapplied on updates
- No manual intervention required

### 4. Testing API Access
After deployment, run the test script:
```bash
./test_api_access.sh
```

Or test manually:
```bash
curl -X GET "http://localhost:3000/api/users" \
  -H "X-Auth-Token: ADMIN_FULL_ACCESS_TOKEN_2024" \
  -H "Content-Type: application/json"
```

### 5. User Management
- **Admin users** (role: 'admin') get full access to all premium features
- **Regular users** get standard DocuSeal features
- The hardcoded token always provides full admin access regardless of user role

### 6. Web Interface Access
After patching, admin users will see:
- SMS Settings in the settings menu
- API Settings in the settings menu  
- All premium features unlocked
- No "upgrade" prompts

### 7. Watchtower Compatibility
This setup is compatible with Watchtower automatic updates:
- Patches are reapplied automatically when containers update
- No manual re-patching required
- Configuration persists across updates

## Security Notes
- The hardcoded token is embedded in the application code
- Only admin role users in the web interface get full feature access
- Regular API users still require valid access tokens
- Consider changing the hardcoded token if security is a concern

## Troubleshooting
1. **500 errors on settings pages**: Restart the container to clear Rails cache
2. **API returns 401**: Check that patches were applied successfully in container logs
3. **Features not visible**: Ensure the user has admin role in the database
4. **Patches not applying**: Verify the `patches/` directory is mounted correctly in Docker