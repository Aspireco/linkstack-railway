#!/bin/sh
set -e

# Fix permissions on the Railway-mounted /htdocs volume so the apache user can
# write (httpd.pid, SQLite DB, uploads). Only effective when running as root,
# which we force via the Dockerfile's `USER root` directive.
if [ -d "/htdocs" ]; then
  chown -R apache:apache /htdocs 2>/dev/null || true
  chmod -R u+rwX,g+rX,o+rX /htdocs 2>/dev/null || true
fi

# Hand off to the real LinkStack entrypoint.
# Per linkstack-org/linkstack-docker Dockerfile, the script lives at
# /usr/local/bin/docker-entrypoint.sh and is the image's default CMD.
exec /usr/local/bin/docker-entrypoint.sh "$@"
