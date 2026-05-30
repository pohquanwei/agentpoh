# agentpoh — Hermes Agent on Railway (password + IP allowlist)

Self-hosted [Hermes Agent](https://github.com/NousResearch/hermes-agent) (Nous Research),
built **from the official upstream image** — no third-party template — and fronted by
**your own** tiny Caddy proxy that adds a password and an IP allowlist.

## Phase 1 (now): just get Hermes running

Deploy **only the `hermes` service** and give it a public domain on port `9119`.
Skip the `edge` service for now. The dashboard boots with `HERMES_DASHBOARD_INSECURE=1`,
so it's reachable with no login yet — **treat the URL as a secret** until Phase 2.

1. Push the repo (`git add -A && git commit -m "Hermes on Railway" && git push -u origin main`).
2. Railway → New Project → Deploy from GitHub repo → `agentpoh`. Rename service `hermes`.
3. **Settings → Volumes → Add Volume**, mount path **`/opt/data`** (before first use).
4. **Variables:** `API_SERVER_ENABLED=true`, `API_SERVER_KEY=<openssl rand -hex 32>`.
5. **Settings → Networking → Generate Domain**, target port **`9119`**.
6. Open the URL → configure Codex (Providers → OpenAI Codex OAuth) → start chatting.

**Phase 2 (later):** add the password + IP allowlist by deploying the `edge` service and
removing the public domain from `hermes`. See the full architecture below.

---

## Architecture (two Railway services, one repo) — Phase 2

```
Internet ──▶ edge (Caddy, PUBLIC)  ──private network──▶ hermes (PRIVATE)
             • IP allowlist                              • web dashboard :9119
             • password (basic auth)                     • gateway API     :8642
                                                         • data in /opt/data (volume)
```

- **`hermes`** service — the official image. WebUI + admin dashboard on `9119`,
  gateway on `8642`. **No public domain** — only reachable via the private network.
  Auth is intentionally off (`HERMES_DASHBOARD_INSECURE=1`) because the edge handles it.
- **`edge`** service — Caddy. The only public service. Enforces IP allowlist + password,
  then proxies to `hermes.railway.internal:9119`.

## Files

| File | Service | Purpose |
|------|---------|---------|
| `Dockerfile`, `railway.toml` | hermes | Official image + dashboard config |
| `edge/Dockerfile`, `edge/Caddyfile`, `edge/railway.toml` | edge | Password + IP allowlist proxy |

---

## Deploy steps

### 1. Push this repo
```bash
git add -A
git commit -m "Hermes Agent on Railway with edge auth + IP allowlist"
git push -u origin main
```

### 2. Create the `hermes` service
- Railway → **New Project → Deploy from GitHub repo → `pohquanwei/agentpoh`**.
- Rename the service to **`hermes`** (the private hostname becomes `hermes.railway.internal`).
- **Root Directory:** leave as `/` (repo root).
- **Settings → Networking:** do **NOT** generate a public domain. Keep it private.
- **Settings → Volumes → Add Volume**, mount path **`/opt/data`** (before first use!).
- **Variables:**
  | Variable | Value |
  |----------|-------|
  | `API_SERVER_ENABLED` | `true` |
  | `API_SERVER_KEY` | `openssl rand -hex 32` |

### 3. Create the `edge` service (same repo)
- In the same project → **New → GitHub Repo → `agentpoh`** again (second service).
- Rename to **`edge`**.
- **Settings → Root Directory:** `edge`  ← important; Caddy builds from `edge/`.
- **Settings → Networking → Generate Domain** (this is your public URL).
- **Variables:**
  | Variable | Value |
  |----------|-------|
  | `HERMES_UPSTREAM` | `hermes.railway.internal:9119` |
  | `ALLOWED_IPS` | your CIDRs, space-separated, e.g. `203.0.113.5/32 198.51.100.0/24` |
  | `BASIC_AUTH_USER` | `admin` (or anything) |
  | `BASIC_AUTH_HASH` | bcrypt hash of your password (see below) |
  | `TRUSTED_PROXIES` | leave unset for Railway-only; set to Cloudflare ranges if using Cloudflare |

  Generate the bcrypt hash locally:
  ```bash
  docker run --rm caddy:2-alpine caddy hash-password --plaintext 'YOUR_PASSWORD'
  ```
  Paste the `$2a$...` output as `BASIC_AUTH_HASH`. (In Railway, wrap it in quotes so
  the `$` signs aren't treated as references.)

### 4. Use it
- Open the **edge** service's public URL.
- You'll get a browser **password** prompt (basic auth). Wrong IP → `403 Forbidden`.
- After auth you're in the Hermes **WebUI + admin dashboard**.

### 5. Configure Codex + vision
- In the dashboard → Providers → **OpenAI Codex (OAuth)** → device-code login
  (open the URL, enter the code) with your **paid ChatGPT** account. Set Codex as your
  main/chat model.
- Vision works automatically — Codex OAuth supports it via `gpt-5.3-codex`.
- No-subscription alternative: use **OpenRouter** (one API key, also supports vision).

---

## About the IP allowlist — read this

Railway has **no native inbound IP allowlist**, so the edge proxy does it by reading
`X-Forwarded-For`. Two trust levels:

- **Railway-only (default):** `TRUSTED_PROXIES` unset → Caddy trusts all proxies and
  reads the forwarded client IP. This works, but a determined attacker could spoof the
  `X-Forwarded-For` header. The **password still protects you** — treat IP filtering
  here as a useful extra layer, not a hard boundary.
- **Bulletproof IP allowlist (recommended): put Cloudflare in front.**
  1. Add a Cloudflare-proxied custom domain (orange cloud) pointing at the edge's
     Railway domain.
  2. Cloudflare dashboard → **Security → WAF → Tools → IP Access Rules**: allow your
     IPs, block everything else. (Or use **Cloudflare Zero Trust → Access** for
     identity-based login instead of/with the password.)
  3. Set `TRUSTED_PROXIES` on the edge service to
     [Cloudflare's IP ranges](https://www.cloudflare.com/ips/) so spoofing is impossible.
  4. Use the Cloudflare domain; don't share the raw `*.up.railway.app` URL.

## Security notes
- Only the `edge` service is public. The `hermes` service must stay private.
- Use a strong `API_SERVER_KEY` and a strong basic-auth password.
- Always confirm the `/opt/data` volume is attached — it holds memory **and** your
  Codex login; without it, both are wiped on redeploy.
- Secrets live only in Railway Variables, never in the repo.
