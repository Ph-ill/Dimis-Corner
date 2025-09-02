# Stage 1: Build the Hugo site
FROM klakegg/hugo:ext-alpine AS builder

# Set the working directory
WORKDIR /src

# Copy the entire project into the container
COPY . .

# Build the Hugo site with production settings
RUN hugo --minify --gc --enableGitInfo

# Stage 2: Serve the site with Nginx
FROM nginx:1.27-alpine

# Copy the generated site from the builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
