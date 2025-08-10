# Multi-stage build for React frontend
FROM node:18-alpine AS build

# Install curl for healthcheck in final stage
RUN apk add --no-cache curl

# Set working directory
WORKDIR /app

# Set npm configuration and environment variables
ENV npm_config_cache=/tmp/.npm
ENV npm_config_fund=false
ENV npm_config_audit=false
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# Copy package files first for better layer caching
COPY client/package*.json ./

# Clean install with specific npm version to avoid issues
RUN npm install -g npm@10.8.2 && \
    npm ci && \
    npm cache clean --force

# Copy source code
COPY client/ ./

# Build the application
RUN npm run build

# Production stage with Nginx
FROM nginx:alpine

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy built assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Set proper permissions for nginx user (already exists in nginx:alpine)
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
