# Hermes Agent — self-hosted on Railway, built from the official upstream image.
# The official image already bundles the web dashboard (WebUI + admin page) and
# the gateway (OpenAI-compatible API). We only layer non-secret runtime config here.
# Secrets (passwords, API keys) are injected via Railway Variables, never baked in.

FROM nousresearch/hermes-agent:latest

# Turn on the built-in web dashboard and bind it to all interfaces so the edge
# proxy can reach it over Railway's PRIVATE network. 9119 = dashboard,
# 8642 = gateway API + /health.
#
# HERMES_DASHBOARD_INSECURE=1: the official dashboard fails closed at startup if
# it binds to a non-loopback address with no OAuth provider configured. We turn
# that gate off here ON PURPOSE because authentication + IP allowlisting are done
# by the Caddy edge service (see ./edge). This Hermes service must NOT be given a
# public Railway domain — only the edge service is public.
# HERMES_DASHBOARD_TUI=1 adds the embedded "Chat" tab (the full Hermes TUI in the
# browser). Without it the dashboard is admin/observability only — no chat box.
# Bind to :: (IPv6 dual-stack) so the dashboard is reachable BOTH on Railway's
# public proxy AND over Railway's private network (which is IPv6-only) from the
# edge proxy at hermes.railway.internal:9119.
ENV HERMES_DASHBOARD=1 \
    HERMES_DASHBOARD_HOST=:: \
    HERMES_DASHBOARD_PORT=9119 \
    HERMES_DASHBOARD_INSECURE=1 \
    HERMES_DASHBOARD_TUI=1 \
    API_SERVER_HOST=0.0.0.0 \
    API_SERVER_CORS_ORIGINS=*

EXPOSE 9119 8642

# Inherit the official /init (s6-overlay) entrypoint; run the gateway, which also
# supervises the dashboard when HERMES_DASHBOARD=1.
CMD ["gateway", "run"]
