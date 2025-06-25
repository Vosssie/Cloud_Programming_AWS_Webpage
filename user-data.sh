#!/bin/bash
cat > /var/www/html/config.js <<EOF
window.config = {
  cognito: {
    userPoolId: '${cognito_user_pool_id}',
    clientId: '${cognito_client_id}',
    region: '${region}'
  },
  domain: '${domain_name}'
};
EOF

# Rest of your user data script