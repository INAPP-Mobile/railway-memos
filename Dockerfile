# =============================================================================
# Railway Template: Memos
# Official Docker image: https://hub.docker.com/r/neosmemo/memos
# GitHub: https://github.com/usememos/memos
# License: MIT
# =============================================================================

# Use the official pinned image for reproducible builds
# Pin to the `stable` tag (Memos' rolling release following v0.29.x).
# Replace with a specific digest for production reproducibility:
#   docker pull neosmemo/memos:stable && docker inspect --format='{{index .RepoDigests 0}}' neosmemo/memos:stable
FROM neosmemo/memos:stable

# ---------------------------------------------------------------------------
# Railway Health Check
# Memos exposes a /health endpoint by default on its HTTP port.
# ---------------------------------------------------------------------------
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${MEMOS_PORT:-5230}/health || exit 1

# ---------------------------------------------------------------------------
# Default environment variables
# ---------------------------------------------------------------------------
ENV MEMOS_PORT=5230 \
    TZ=UTC

# ---------------------------------------------------------------------------
# Port exposed by Memos
# ---------------------------------------------------------------------------
EXPOSE 5230

# ---------------------------------------------------------------------------
# Use the official entrypoint:
#   1. Fixes data directory ownership (drops from root to nonroot)
#   2. Reads MEMOS_DSN (supports Docker secrets via _FILE suffix)
#   3. Execs the memos binary
# ---------------------------------------------------------------------------
ENTRYPOINT ["/usr/local/memos/entrypoint.sh"]
CMD ["/usr/local/memos/memos", "--port", "5230", "--data", "/var/opt/memos"]
