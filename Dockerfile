FROM linkstackorg/linkstack:latest

# Force root so we can fix /htdocs ownership on the Railway-mounted volume.
# LinkStack's stock image runs as the apache user, which has no perms to chmod
# a Railway volume mount (root-owned by default).
USER root

COPY entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
