# Stage 1: Build the Hugo site
FROM hugomods/hugo:exts AS builder

# Set the working directory
WORKDIR /src

# Copy the entire project into the container
COPY . .

# Build the Hugo site with production settings
# Use conditional Git info - only if .git directory exists
RUN if [ -d ".git" ]; then \
        hugo --minify --gc --enableGitInfo; \
    else \
        hugo --minify --gc; \
    fi

# Stage 2: Serve the site with Nginx
FROM nginx:1.27-alpine

# Copy the generated site from the builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
