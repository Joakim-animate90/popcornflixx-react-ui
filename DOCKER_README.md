# 🐳 Docker & CI/CD Setup for PopcornFlix Frontend

## 📁 Overview

This project includes a comprehensive Docker and CI/CD setup for automated building, testing, and deployment of the React frontend application.

## 🚀 Quick Start

### Local Development
```bash
# Development mode with hot reload
docker-compose --profile dev up frontend-dev

# Production mode
docker-compose up frontend

# Build and test locally
./test-build.sh

# Security scan
./security-scan.sh
```

## 📋 Files Structure

```
├── Dockerfile                 # Main production Dockerfile (AMD64)
├── Dockerfile.dev            # Development Dockerfile
├── Dockerfile.multiarch      # Multi-architecture support (experimental)
├── docker-compose.yml        # Docker Compose configuration
├── nginx.conf               # Nginx configuration for production
├── .dockerignore            # Docker build context exclusions
├── test-build.sh            # Local build testing script
├── security-scan.sh         # Local security scanning script
└── .github/workflows/
    ├── deploy.yml           # Main CI/CD pipeline
    ├── multiarch.yml        # Multi-architecture builds
    ├── security-scan.yml    # Security scanning
    └── release.yml          # Version management
```

## 🔧 Docker Configuration

### Main Dockerfile
- **Base Images**: `node:18-alpine` (build) → `nginx:alpine` (runtime)
- **Multi-stage build** for optimal image size
- **Security**: Non-root nginx user, proper permissions
- **Health checks** included
- **Platform**: AMD64 (most stable)

### Development Dockerfile
- **Hot reload** support with volume mounting
- **Development dependencies** included
- **Port**: 5173 (Vite default)

### Nginx Configuration
- **SPA routing** support (React Router)
- **Gzip compression** enabled
- **Security headers** configured
- **Static asset caching** (1 year)
- **Health endpoint**: `/health`

## 🚀 GitHub Actions Workflows

### 1. Main Deploy Workflow (`deploy.yml`)
**Triggers**: Push to main/develop, tags, PRs

**Features**:
- ✅ Node.js setup with dependency caching
- ✅ ESLint and build validation
- ✅ Docker build and push to GHCR
- ✅ PR testing with health checks
- ✅ Automatic tagging strategy

**Image Tags Generated**:
```
ghcr.io/joakim-animate90/popcornflix-frontend:latest          # main branch
ghcr.io/joakim-animate90/popcornflix-frontend:main            # main branch
ghcr.io/joakim-animate90/popcornflix-frontend:1.0.0          # semantic versions
ghcr.io/joakim-animate90/popcornflix-frontend:main-abc123    # commit-specific
```

### 2. Security Scan Workflow (`security-scan.yml`)
**Triggers**: After successful deployment, manual

**Features**:
- ✅ Trivy vulnerability scanning
- ✅ SARIF reports for GitHub Security tab
- ✅ Human-readable table output
- ✅ Artifact storage for reports
- ✅ Non-blocking (won't fail deployments)

### 3. Multi-Architecture Workflow (`multiarch.yml`)
**Triggers**: Manual only

**Features**:
- ✅ AMD64 and ARM64 builds
- ✅ QEMU emulation setup
- ✅ Experimental multi-platform support

### 4. Release Workflow (`release.yml`)
**Triggers**: Manual with version selection

**Features**:
- ✅ Semantic version bumping (patch/minor/major)
- ✅ Git tagging and GitHub releases
- ✅ Automated changelog generation

## 🏷️ Versioning Strategy

### Semantic Versioning
- **patch**: Bug fixes (1.0.0 → 1.0.1)
- **minor**: New features (1.0.0 → 1.1.0)
- **major**: Breaking changes (1.0.0 → 2.0.0)

### Image Tags
- `latest`: Always points to main branch
- `1.0.0`: Specific version
- `1.0`: Major.minor version
- `1`: Major version only
- `main-abc123`: Branch-specific with commit SHA

## 🔒 Security Features

### Image Security
- ✅ Minimal Alpine base images
- ✅ Non-root user execution
- ✅ Security headers in Nginx
- ✅ Regular vulnerability scanning

### CI/CD Security
- ✅ GitHub token authentication
- ✅ Secrets management
- ✅ Read-only permissions where possible
- ✅ Branch protection rules compatible

## 📊 Performance Optimizations

### Build Performance
- ✅ Docker layer caching
- ✅ GitHub Actions cache
- ✅ Multi-stage builds
- ✅ .dockerignore optimization

### Runtime Performance
- ✅ Gzip compression
- ✅ Static asset caching
- ✅ Optimized Nginx configuration
- ✅ Health checks for reliability

## 🛠️ Local Development Tools

### Build Testing (`test-build.sh`)
```bash
./test-build.sh [image-name]
```
- ✅ Automated Docker build testing
- ✅ Health check validation
- ✅ Platform detection
- ✅ Color-coded output

### Security Scanning (`security-scan.sh`)
```bash
./security-scan.sh [image-name]
```
- ✅ Trivy installation and setup
- ✅ Vulnerability counting and reporting
- ✅ Cross-platform support
- ✅ JSON report generation

## 🚀 Deployment Guide

### Automatic Deployment
1. **Push to main** → Triggers build and deploy
2. **Create tag** → Creates versioned release
3. **Manual release** → Bumps version and deploys

### Manual Deployment
```bash
# Build specific version
docker build -t ghcr.io/joakim-animate90/popcornflix-frontend:1.0.0 .

# Push to registry
docker push ghcr.io/joakim-animate90/popcornflix-frontend:1.0.0

# Run locally
docker run -p 3000:80 ghcr.io/joakim-animate90/popcornflix-frontend:1.0.0
```

## 🔧 Configuration

### Environment Variables
- `NODE_ENV`: production/development
- `REGISTRY`: ghcr.io
- `IMAGE_NAME`: joakim-animate90/popcornflix-frontend

### Ports
- **Production**: 3000:80 (docker-compose)
- **Development**: 5173:5173 (docker-compose)
- **Nginx**: 80 (container internal)

## 📝 Best Practices

### Docker
1. Use multi-stage builds for smaller images
2. Copy package.json before source code for better caching
3. Use specific base image versions
4. Run as non-root user
5. Include health checks

### CI/CD
1. Cache dependencies for faster builds
2. Use semantic versioning
3. Separate build and security concerns
4. Test PRs before merging
5. Don't fail deployments on security scans

### Security
1. Regular vulnerability scanning
2. Minimal base images
3. Security headers
4. Secrets management
5. Principle of least privilege

## 🐛 Troubleshooting

### Common Issues

1. **Build fails on ARM64**
   - Use main Dockerfile (AMD64 only)
   - Or use multiarch workflow for experimental ARM64 support

2. **npm config errors**
   - Invalid npm options have been removed
   - Use environment variables instead

3. **Permission denied in nginx**
   - Fixed with proper chown/chmod in Dockerfile

4. **Security scan failures**
   - Scans run separately and won't block deployment
   - Check Security tab for detailed reports

### Getting Help
- Check GitHub Actions logs for build issues
- Use local scripts for debugging
- Review Docker build context with .dockerignore
- Validate Nginx config syntax

## 🎯 Future Improvements

1. **Multi-architecture support** (when Rollup ARM64 issues resolved)
2. **Automated security remediation**
3. **Performance monitoring integration**
4. **Deployment notifications**
5. **Backup and rollback strategies**
