# Stage 1: build node.js application
FROM scratch AS builder

# Add the alpine minirootfs
ADD src/alpine-minirootfs-3.19.1-x86_64.tar.gz /

# install Node.js and npm
RUN apk add --update nodejs npm

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies including 'express'
RUN npm install

# Copy application code
COPY index.js ./
COPY src ./src

# Stage 2: Create a minimal image on Nginx
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
  CMD curl -f http://localhost || exit 1

# Start Nginx and the Node.js application
CMD ["sh", "-c", "nginx & node /app/index.js"]
