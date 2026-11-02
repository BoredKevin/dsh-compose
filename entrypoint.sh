#!/bin/sh
set -e

EXTRA_ARGS=""

if [ -n "$DSH_TRUSTED_HOST" ]; then
  for host in $(echo "$DSH_TRUSTED_HOST" | tr ',' ' '); do
    EXTRA_ARGS="$EXTRA_ARGS --trusted-host $host"
  done
fi

if [ -n "$DSH_PUBLIC_URL" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --public-url $DSH_PUBLIC_URL"
fi

echo "Starting DeepSeek Harness on port 3080..."
exec dsh web --port 3080 --no-open $EXTRA_ARGS "$@"
