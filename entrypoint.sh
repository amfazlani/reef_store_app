#!/bin/sh

set -e

# Remove stale pid file
rm -f tmp/pids/server.pid

# Run migrations (dev only — be cautious in prod!)
bundle exec rails db:migrate db:seed

# Start the server
exec "$@"

