FROM linkstackorg/linkstack:latest

# Force root so we can fix /htdocs ownership on the Railway-mounted volume.
# LinkStack's stock image runs as the apache user, which has no perms to chmod
# a Railway volume mount (root-owned by default).
USER root

# Stash a pristine copy of the bundled LinkStack content somewhere the volume
# mount can't shadow. On first boot the volume at /htdocs is empty, so the
# entrypoint copies this seed into place.
RUN cp -a /htdocs /opt/linkstack-seed && chown -R apache:apache /opt/linkstack-seed

COPY entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
