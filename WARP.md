# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**Dimi's Corner** is a Hugo static site deployed as a containerized application using Docker and Nginx. The project follows a production-ready architecture with multi-stage Docker builds and is designed for deployment via Portainer GitOps workflow.

- **Site URL**: https://dimiscorner.coolphill.com
- **Static Site Generator**: Hugo
- **Containerization**: Docker with multi-stage builds
- **Web Server**: Nginx (for serving static files)
- **Deployment**: Docker Compose + Portainer GitOps

## Architecture

### Container Architecture
The project uses a **multi-stage Docker build**:
1. **Stage 1 (Builder)**: Uses `klakegg/hugo:ext-alpine` to build the Hugo site
2. **Stage 2 (Runtime)**: Uses `nginx:1.27-alpine` to serve the generated static files

### Directory Structure
```
dimis-corner/
├── config.toml          # Hugo configuration
├── content/             # Hugo content (Markdown files)
│   └── _index.md       # Homepage content
├── themes/             # Hugo themes (currently empty)
├── nginx/              # Nginx configuration
│   └── default.conf    # Custom Nginx server configuration
├── Dockerfile          # Multi-stage build definition
└── docker-compose.yml  # Container orchestration
```

### Network Configuration
- The application connects to an external Docker network named `Shared`
- This network is managed by Nginx Proxy Manager for reverse proxy functionality
- Container exposes port 80 internally

## Development Commands

### Building and Running

#### Build the Docker image:
```bash
docker build -t dimis-corner .
```

#### Run with Docker Compose:
```bash
docker-compose up -d
```

#### Stop the application:
```bash
docker-compose down
```

#### Rebuild and restart:
```bash
docker-compose up -d --build
```

### Content Development

#### Add new content:
Create new Markdown files in the `content/` directory following Hugo's content structure.

#### Edit site configuration:
Modify `config.toml` to change site title, baseURL, or other Hugo settings.

### Local Development (with Hugo installed)
If Hugo is installed locally, you can develop without Docker:

```bash
# Install Hugo first (not available in current environment)
hugo server -D  # Run development server with drafts
hugo --minify   # Build for production
```

### Container Management

#### View running containers:
```bash
docker-compose ps
```

#### View container logs:
```bash
docker-compose logs -f hugo
```

#### Enter the container:
```bash
docker exec -it hugo_nginx sh
```

### Git Workflow
The project follows a Git-based deployment model:
- Changes pushed to master trigger automatic deployments via Portainer GitOps
- The deployment history shows evolution from various container configurations to the current multi-stage setup

## Key Files

- **`config.toml`**: Hugo site configuration (title, baseURL, language)
- **`Dockerfile`**: Multi-stage build with Hugo compilation and Nginx serving
- **`docker-compose.yml`**: Defines the service and external network configuration
- **`nginx/default.conf`**: Custom Nginx configuration for serving static files
- **`content/_index.md`**: Homepage content in Markdown format

## Deployment Notes

- The site is deployed to `https://dimiscorner.coolphill.com`
- Uses Portainer for container orchestration
- Requires the `Shared` external Docker network to be created before deployment
- The multi-stage build optimizes the final image size by excluding Hugo build tools from the runtime image
- Hugo builds with `--minify --gc --enableGitInfo` flags for production optimization

## Theme Management

Currently, no specific Hugo theme is configured. The site uses Hugo's default rendering. To add a theme:

1. Add the theme to the `themes/` directory (via git submodule or direct download)
2. Update `config.toml` to specify the theme: `theme = "theme-name"`
3. Rebuild the Docker image to include theme changes
