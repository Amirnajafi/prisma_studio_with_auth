#!/bin/sh

# Check if the required environment variables are set
if [ -z "$DATABASE_URL" ]; then
  echo "Error: DATABASE_URL environment variable must be set."
  exit 1
fi

# Change to the Prisma directory
cd /app/prisma

# Initialize Prisma schema and introspect the database
echo "datasource db {
  provider = \"postgresql\"
  url      = env(\"DATABASE_URL\")
}

generator client {
  provider = \"prisma-client-js\"
}" > schema.prisma

# Introspect the database to update the Prisma schema
npx prisma db pull --schema /app/prisma/schema.prisma

# Generate Prisma client
npx prisma generate --schema /app/prisma/schema.prisma

# Start supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf