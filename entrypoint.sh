#!/bin/sh
set -e

SEED=/opt/linkstack-seed
DATA=/htdocs

# First-boot seed: if the Railway volume is empty (no LinkStack core file),
# copy the bundled LinkStack release into it. Detect via version.json which
# always exists in a real LinkStack tree.
if [ ! -f "$DATA/version.json" ]; then
  echo "[railway-entrypoint] /htdocs empty — seeding from $SEED"
  # cp -a preserves perms/ownership/symlinks; the trailing /. copies contents
  # without nesting the seed dir inside the target.
  cp -a "$SEED/." "$DATA/"
fi

# Always re-assert ownership (volume mounts come up root-owned each boot).
chown -R apache:apache "$DATA" 2>/dev/null || true
chmod -R u+rwX,g+rX,o+rX "$DATA" 2>/dev/null || true

# Hand off to the real LinkStack entrypoint.
exec /usr/local/bin/docker-entrypoint.sh "$@"
