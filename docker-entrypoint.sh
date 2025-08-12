#!/bin/sh

# Runtime environment variable injection for React app
# This script runs before nginx starts to inject environment variables

# Create the env-config.js file
cat <<EOF > /usr/share/nginx/html/env-config.js
window._env_ = {
  REACT_APP_API_URL: "${REACT_APP_API_URL}",
  REACT_APP_APP_NAME: "${REACT_APP_APP_NAME}",
  REACT_APP_VERSION: "${REACT_APP_VERSION}",
  REACT_APP_ENABLE_ANALYTICS: "${REACT_APP_ENABLE_ANALYTICS}",
  REACT_APP_DEBUG_MODE: "${REACT_APP_DEBUG_MODE}",
  REACT_APP_TMDB_API_URL: "${REACT_APP_TMDB_API_URL}"
};
EOF

# Start nginx
exec "$@"
