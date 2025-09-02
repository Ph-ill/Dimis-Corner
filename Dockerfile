# Stage 1: Build the Hugo site
FROM hugomods/hugo:exts AS builder

# Set the working directory
WORKDIR /src

# Copy the entire project into the container
COPY . .

# Debug: List contents to verify copy worked
RUN echo "=== Verifying project files ===" && \
    ls -la && \
    echo "=== Verifying themes ===" && \
    ls -la themes/ && \
    echo "=== Verifying content ===" && \
    ls -la content/

# Build the Hugo site with explicit error checking
RUN echo "=== Starting Hugo build ===" && \
    hugo --minify --gc && \
    echo "=== Hugo build completed ===" && \
    echo "=== Verifying public directory ===" && \
    ls -la public/ && \
    echo "=== Checking index.html ===" && \
    ls -la public/index.html && \
    head -5 public/index.html

# Stage 2: Serve the site with Nginx
FROM nginx:1.27-alpine

# Remove default nginx files first
RUN rm -rf /usr/share/nginx/html/*

# Copy the generated site from the builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Verify the copy worked
RUN echo "=== Verifying nginx files ===" && \
    ls -la /usr/share/nginx/html/ && \
    echo "=== Checking index.html in nginx ===" && \
    ls -la /usr/share/nginx/html/index.html && \
    head -5 /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
