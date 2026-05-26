# linkstack-railway

Thin wrapper over [linkstackorg/linkstack](https://hub.docker.com/r/linkstackorg/linkstack) so it can run with a [Railway](https://railway.com) persistent volume mounted at `/htdocs`.

## Why this exists

LinkStack's official image runs as the unprivileged `apache` user. Railway mounts volumes root-owned, so apache can't write `httpd.pid`, the SQLite DB, or uploads, and the container crash-loops with:

```
[core:error] (13)Permission denied: AH00099: could not create /htdocs/httpd.pid.XXXXXX
```

This wrapper:
1. Switches the image's `USER` back to `root` so the entrypoint runs privileged.
2. Runs `chown -R apache:apache /htdocs` to make the volume mount writable.
3. Hands off to LinkStack's original `/entrypoint.sh` which drops privileges itself.

## Deploying

Point a Railway service at this repo — it will detect the Dockerfile and build automatically. Mount a persistent volume at `/htdocs`. That's it.

### Env vars (optional)

| Var | Default | Purpose |
|---|---|---|
| `SERVER_ADMIN` | _(unset)_ | Apache admin email shown in error pages |
| `TZ` | UTC | Timezone (e.g. `America/Toronto`) |
| `LOG_LEVEL` | `warn` | Apache log level |
| `PHP_MEMORY_LIMIT` | `256M` | PHP memory limit |
