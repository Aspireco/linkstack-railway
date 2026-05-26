#!/bin/sh
set -e

# Fix permissions on the Railway-mounted /htdocs volume so apache can write
# (httpd.pid, SQLite DB, uploads). Only effective when running as root, which
# we force via the Dockerfile.
if [ -d "/htdocs" ]; then
  chown -R apache:apache /htdocs 2>/dev/null || true
  chmod -R u+rwX,g+rX,o+rX /htdocs 2>/dev/null || true
fi

# Hand off to the original LinkStack entrypoint
exec /entrypoint.sh "$@"
