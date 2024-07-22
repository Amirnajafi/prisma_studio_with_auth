# Use the official NGINX image as the base image
FROM nginx:alpine


ENV BASIC_AUTH_USER=$BASIC_AUTH_PASSWORD
ENV BASIC_AUTH_PASSWORD=$BASIC_AUTH_PASSWORD
ENV PROJECT_NAME=$PROJECT_NAME
ENV POSTGRES_URL=$POSTGRES_URL
ENV DATABASE_URL=$DATABASE_URL


# Install necessary packages
RUN apk add --no-cache \
    nodejs \
    npm \
    supervisor \
    apache2-utils \
    postgresql-client

# Install Prisma CLI
RUN npm install -g prisma

# Create directory for supervisor configuration and logs
RUN mkdir -p /etc/supervisor/conf.d /var/log/supervisor /var/log/nginx /app/prisma

# Copy the custom NGINX configuration file to the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the supervisor configuration file to the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Script to generate the htpasswd file
COPY create_htpasswd.sh /usr/local/bin/create_htpasswd.sh
RUN chmod +x /usr/local/bin/create_htpasswd.sh

# Script to introspect the database, generate Prisma schema, Prisma client, and start supervisor
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80
EXPOSE 80

# Command to create htpasswd file, introspect the database, generate Prisma schema and client, and start supervisor
CMD ["/bin/sh", "-c", "/usr/local/bin/create_htpasswd.sh && /usr/local/bin/entrypoint.sh"]