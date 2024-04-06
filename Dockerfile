# Stage 1: Build the Node.js application
FROM scratch AS builder

# Add the Alpine minirootfs
ADD alpine-minirootfs-3.19.1-x86_64.tar.gz /

# Install Node.js and npm
RUN apk add --update nodejs npm

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available) to work directory
COPY package*.json ./

# Install app dependencies including 'express'
RUN npm install

# Copy the rest of the application code
COPY . .

# Stage 2: Create a minimal image using Nginx
FROM nginx:alpine

# Build argument for version
ARG VERSION=1.0.0

# Use the build argument to set an environment variable
ENV VERSION=${VERSION}

# Install Node.js
RUN apk add --update nodejs

# Copy the application code from the builder stage
COPY --from=builder /app /app

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy a custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Expose the port the app runs on
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8083 || exit 1

# Start Nginx and the Node.js application
CMD ["sh", "-c", "nginx & node /app/index.js"]
