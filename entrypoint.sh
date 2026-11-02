#!/bin/sh
set -e

echo "=== Initializing DeepSeek Harness Container ==="
echo "Node version: $(node -v)"
echo "DSH version: $(dsh -V 2>&1 || echo 'unknown')"

# 1. Automatically fix ownership of persistent mounted volumes
mkdir -p /home/node/.dsh /workspace
chown -R node:node /home/node /workspace
export HOME=/home/node
export DSH_HOME=/home/node/.dsh

# 2. Build extra arguments
EXTRA_ARGS=""

if [ -n "$DSH_TRUSTED_HOST" ]; then
  for host in $(echo "$DSH_TRUSTED_HOST" | tr ',' ' '); do
    EXTRA_ARGS="$EXTRA_ARGS --trusted-host $host"
  done
fi

if [ -n "$DSH_PUBLIC_URL" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --public-url $DSH_PUBLIC_URL"
fi

echo "Trusted Host: ${DSH_TRUSTED_HOST:-none}"
echo "Public URL: ${DSH_PUBLIC_URL:-none}"
echo "Executing: dsh web --port 3080 --no-open $EXTRA_ARGS $@"

# 3. Run dsh safely as non-root user 'node' using gosu
set +e
gosu node dsh web --port 3080 --no-open $EXTRA_ARGS "$@"
EXIT_CODE=$?

echo "DeepSeek Harness process terminated with exit code: $EXIT_CODE"

# Dump diagnostic logs if any were generated under DSH_HOME/logs
if [ -d /home/node/.dsh/logs ]; then
  echo "--- Diagnostic logs in /home/node/.dsh/logs ---"
  ls -la /home/node/.dsh/logs
  for f in /home/node/.dsh/logs/*.log; do
    if [ -f "$f" ]; then
      echo "=== Log file: $f ==="
      cat "$f"
    fi
  done
fi

# Pause 30s before exit to stop 1-second crash loops and allow inspection
echo "Container pausing 30 seconds before exit..."
sleep 30

exit $EXIT_CODE
