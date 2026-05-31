# 🤖 Hermes Agent on Railway — Complete Fresh-Start Guide

Set up your own personal AI assistant (**Hermes Agent**) from **absolute zero** —
hosted in the cloud, reachable from **Telegram** and **WhatsApp**, able to read web
pages, and (recommended) locked so only you can use it.

Written for **non-technical people**. Every "how do I get this?" step is spelled out.

> 💡 **The big picture**
> You rent a small always-on computer in the cloud (**Railway**), install a smart
> assistant on it (**Hermes**), give it a brain (**an AI model**), connect ways to
> chat (**web, Telegram, WhatsApp**), and finally put a locked front door on it
> (**password + your IP**).

---

## 📑 Contents

- [0. What it costs & what you'll need](#0-what-it-costs--what-youll-need)
- [1. Create your accounts](#1-create-your-accounts)
- [2. Deploy the project on Railway](#2-deploy-the-project-on-railway)
- [3. Add permanent storage](#3-add-permanent-storage)
- [4. Open a Terminal](#4-open-a-terminal)
- [5. Generate the server key & set variables](#5-generate-the-server-key--set-variables)
- [6. Open the web dashboard (your control panel)](#6-open-the-web-dashboard-your-control-panel)
- [7. Give it a brain (AI model)](#7-give-it-a-brain-ai-model)
- [8. Connect Telegram](#8-connect-telegram)
- [9. Connect WhatsApp](#9-connect-whatsapp)
- [10. Lock the front door (password + IP) — recommended](#10-lock-the-front-door-password--ip--recommended)
- [11. Read protected websites — optional](#11-read-protected-websites--optional)
- [✅ How to use it day-to-day](#-how-to-use-it-day-to-day)
- [🛠️ Troubleshooting](#️-troubleshooting)
- [📋 Quick reference](#-quick-reference)
- [📖 Glossary](#-glossary)

> 🗺️ **Flow:** Steps 1–7 get your assistant **running**. Steps 8–9 let you **use it**
> (Telegram, WhatsApp). Step 10 **locks it down** (recommended). Step 11 is an
> **optional add-on** — let it read protected websites.

---

## 0. What it costs & what you'll need

**💲 What you'll use & what it costs** *(all free to sign up; prices change — rough guide)*

| Item | What it's for | Required? | Rough cost | Subscription? | Remarks |
|---|---|---|---|---|---|
| **GitHub** | Stores the project files | Required | Free | ❌ No | Always free. |
| **Railway** | Runs everything in the cloud | Required | ~US$5–10 / mo | ❌ No | **Start FREE** — trial credit lets you try the whole setup before paying. No subscription. |
| **AI brain — Option 1: API key** (OpenRouter / OpenAI) | The "brain" that writes replies | Required *(pick one)* | ~US$1–5 / mo (light use) | ❌ No | **Pay-as-you-go** — top up a little, set a cap. No commitment. |
| **AI brain — Option 2: Codex** | The "brain" (via your ChatGPT) | Required *(pick one)* | ChatGPT Plus ~US$20 / mo (Pro ~US$200) | ✅ Yes | Uses your ChatGPT subscription; only if you already pay for it. Login can drop (Step 7). |
| **Telegram** | Chat from your phone | Optional | Free | ❌ No | Always free. |
| **WhatsApp** | Chat from WhatsApp | Optional | Free | ❌ No | ⚠️ Use a **separate/spare number** (small ban risk) — a cheap prepaid SIM works. |
| **Browserbase** | Reads protected web pages | Optional | Free tier | ❌ No | Free tier covers light use. |

> 💡 **You only pay for ONE AI brain — pick one:**
> - **API key** → no subscription, pay-as-you-go (~a few dollars/month, you set the
>   cap), and it never gets "kicked out". *Usually cheaper and more reliable for an
>   always-on bot.*
> - **Codex** → needs a paid **ChatGPT subscription (~US$20/month)**; convenient if
>   you already pay for ChatGPT, but the login can drop (see Step 7).
>
> 👉 **Minimum to run this:** Railway **+** one AI brain → roughly **US$6–10/month**
> with an API key, or **~US$25/month** with Codex on ChatGPT Plus.

---

## 1. Create your accounts

Just sign up at each — no setup yet. (You can change the AI brain later.)

| Account | Sign-up link | Notes |
|---|---|---|
| **GitHub** | https://github.com | **Required** — stores the project files |
| **Railway** | https://railway.app | **Required** — easiest: **Login with GitHub** |
| **OpenRouter** — AI brain | https://openrouter.ai | **Pick one AI brain.** Recommended — one key, many models |
| **OpenAI** — AI brain *(alt)* | https://platform.openai.com | Alternative to OpenRouter |
| **Codex** — AI brain *(alt)* | *(no new account)* | Just use your existing **paid ChatGPT** account |
| **Telegram** *(optional)* | the Telegram app | Only if you want to chat from your phone |
| **WhatsApp** *(optional)* | *(no website sign-up)* | ⚠️ Just need a **separate/spare number** with WhatsApp installed (small ban risk) |
| **Browserbase** *(optional)* | https://browserbase.com | Only if you want it to read protected websites |

> 🧠 **Pick just ONE AI brain** (OpenRouter, OpenAI, *or* Codex).

---

## 2. Deploy the project on Railway

The project's files live in this GitHub repo:
**https://github.com/pohquanwei/agentpoh**

1. **Log in to Railway** → https://railway.app (easiest: **Login with GitHub**).
2. Click **New Project → Deploy from GitHub repo** and pick the repo:
   - 👤 **If this is your own repo (you're the owner):** select **`agentpoh`** from
     the list and continue.
   - 👥 **If you're following this guide and it's *not* your repo:** first **fork**
     it — open **https://github.com/pohquanwei/agentpoh** → click **Fork** (top
     right) → GitHub makes a copy in your account → then select **your fork** here.
     *(The repo must be public for you to fork it.)*
3. Railway reads the recipe (`Dockerfile`) and builds it. Wait for the **green
   tick** ✅.
4. Click the service → **Settings → Rename** it to **`agentpoh`**.

> 📝 Its private address becomes **`agentpoh.railway.internal`** — you'll need this
> name in Step 10.

> 🧩 **What "fork" means:** your own copy of a GitHub project, in your account. You
> only need to fork if the repo isn't yours.

---

## 3. Add permanent storage

Without this, the assistant **forgets everything** on every restart. Do this right
after deploying — before you start using it.

1. On the `agentpoh` service: **Settings → Volumes → Add Volume**.
2. Mount path: **`/opt/data`** → Save.

✅ Memory, settings, logins, and chats now survive restarts.

---

## 4. Open a Terminal *(already on your computer — nothing to install)*

> 🔎 **What this step is for:** it's just a helper for two later steps that ask you
> to run a tiny command — creating the **server key** (Step 5) and the **password**
> (Step 10). This is your *own computer's* terminal, **not** the Railway container
> terminal. You can skip it entirely (see the bottom of this step).

A **Terminal** is a plain text window where you type a command and press Enter.
**It's already built into your computer — you don't download or install anything.**

**How to open it:**

- **Mac:** press `Cmd + Space` (this opens the search bar) → type **Terminal** →
  press Enter. A window with text appears — that's the Terminal.
- **Windows:** click the **Start** menu → type **PowerShell** → press Enter.

**How to use it:** when a step shows a command in a grey box, **copy it, click into
the Terminal window, paste, and press Enter.** The answer prints right below — you
copy that answer.

> 🙅 **Prefer not to use a Terminal at all?** You can skip it:
> - **Server key (Step 5):** use any free *"random hex generator"* website to make
>   a 64-character string.
> - **Password (Step 10):** use a free *"bcrypt password generator"* website
>   (use a password you don't reuse elsewhere). Or get the rest set up first and
>   simply **ask the assistant to generate the password hash for you**.

---

## 5. Generate the server key & set variables

### 🔧 Generate the server key

This is a long random key that protects the assistant's API. **You create it
yourself** — keep it secret, and never put it in GitHub.

Open your Terminal (Step 4), run the command for **your** system, and **copy the
long string it prints** (64 characters) — that string *is* your key:

**🍎 Mac (Terminal):**

```bash
openssl rand -hex 32
```

**🪟 Windows (PowerShell):**

```powershell
([guid]::NewGuid().ToString("N") + [guid]::NewGuid().ToString("N"))
```

> 🙅 **No terminal? Use one of these (safest first):**
> 1. **A password manager** — 1Password, Bitwarden, or your browser's built-in
>    password generator. Set the length to ~64 (letters + numbers). It's created
>    **on your device** and saved safely. *(Recommended.)*
> 2. **A client-side generator website** — e.g. **https://it-tools.tech → "Token
>    generator"** (set length to 64). It generates the value **in your browser**, so
>    it never reaches their server.
>
> ⚠️ For a *secret*, **avoid sites that generate it on their server** — prefer one
> that runs on your own device (the two above do). Any long, random, private value
> works; you can also change it later.

### Set the variables (in the Railway website)

Now switch to the **Railway dashboard in your browser** (no terminal needed here):

1. Go to **https://railway.app** and open your **project**.
2. Click the **`agentpoh`** service to open it.
3. Click the **Variables** tab.
4. Click **+ New Variable** and add the first one; repeat for the second:

   | Variable name | Value |
   |----------|-------|
   | `API_SERVER_ENABLED` | `true` |
   | `API_SERVER_KEY` | *(paste the 64-character key you generated above)* |

5. Save. Railway will **automatically redeploy** the service so the new settings
   take effect — wait for the **green tick** ✅.

> 💡 **Faster option:** the Variables tab has a **Raw Editor** — click it and paste
> both lines at once:
> ```
> API_SERVER_ENABLED=true
> API_SERVER_KEY=your-64-character-key-here
> ```

---

## 6. Open the web dashboard (your control panel)

**🔎 What this step is for:** the **dashboard** is your assistant's web **control
panel + chat page** — it's where you pick the AI model, view logs, change settings,
see its memory, and chat. You need to open it now so you can set things up in the
next steps.

> It's **already switched on** by the project — `HERMES_DASHBOARD=1` and the **CHAT**
> tab (`HERMES_DASHBOARD_TUI=1`) are built into the `Dockerfile`, so there's nothing
> to turn on. You just need a way to *reach* it.

**Give it a temporary web address so you can open it:**

1. In Railway → open the **`agentpoh`** service → **Settings → Networking**.
2. Click **Generate Domain**. If it asks which port, enter **`9119`** (the
   dashboard's port).
3. Open the new `…up.railway.app` link in your browser — you'll see the dashboard
   (left menu: **MODELS, LOGS, CHAT, CONFIG, KEYS…**).

> ⚠️ **This link is temporary and has NO password yet** — anyone with it could open
> your assistant. **Treat the link as secret.** In **Step 10** (recommended) you'll
> put it behind a password + IP guard and **remove this public link**, so it's only
> reachable through a locked front door.

---

## 7. Give it a brain (AI model)

> 🖥️ **You can do everything in this step two ways — pick whichever you prefer:**
> - **Dashboard (UI) — easiest, recommended:** all clicks, in your browser.
> - **Terminal:** run commands in the **container shell** (`railway ssh`, or the
>   dashboard's **"Copy SSH Command"**).
>
> ℹ️ **For this first-time setup, use the UI or the container shell** — you *can't*
> "ask the assistant to run it" yet, because the assistant has no brain until you
> finish this step.

Pick **one** path (A or B).

### Path A — API key *(recommended: stable, never "kicked out")*

> 💲 An API key is **pay-as-you-go**, not a subscription. You top up a little, pay
> only for what you use, and can set a spending cap. It keeps working no matter
> where else you log in.

**🔧 Generate an OpenRouter key (recommended):**

1. Go to https://openrouter.ai → sign in.
2. **Settings → Credits** → add a small amount (e.g. US$5).
3. **Settings → Keys → Create Key** → copy it (starts with `sk-or-...`).
4. *(Optional)* set a monthly limit on the key.

**🔧 Or generate an OpenAI key:**

1. https://platform.openai.com → **Billing** → add a small credit.
2. **API keys → Create new secret key** → copy it (starts with `sk-...`).
3. *(Optional)* **Limits → set a monthly budget.**

**Add the key to Hermes — either way:**

- **UI (easiest):** dashboard → **KEYS** → **Add key** → paste it → Save.
- **Terminal** (container shell):
  ```bash
  hermes config set OPENROUTER_API_KEY sk-or-...   # note: a SPACE, not =
  # or
  hermes config set OPENAI_API_KEY sk-...
  ```

**Choose the model — either way:**

- **UI (easiest):** dashboard → **MODELS → MAIN MODEL → CHANGE** → pick a model →
  **Switch**.
- **Terminal:** `hermes config set model <name>` — e.g.
  `hermes config set model anthropic/claude-sonnet-4`.

Good "something good" choices:

- **Claude Sonnet** — great at chat + analysis, reasonable cost *(recommended)*.
- **GPT-5.x** — strong all-rounder.
- **Gemini Flash** — cheapest.

### Path B — Codex *(uses your paid ChatGPT subscription)*

> ✅ **Requires:** a **paid ChatGPT subscription** (Plus ~US$20/month). Without it,
> Codex returns errors. No extra API key or top-up needed — it uses your ChatGPT
> login.

**🔧 Sign in to Codex (one-time device login):**

1. Open the dashboard → **MODELS**.
2. Choose **OpenAI Codex** → it shows a **link and a short code**.
3. Open that link in your browser, type the code, and **approve with your ChatGPT
   account**.
4. Back in **MODELS → MAIN MODEL → CHANGE**, pick a Codex model (e.g.
   `gpt-5.x-codex`) → **Switch**. *(Codex can also read images — vision works.)*
5. Click **↻ Restart Gateway**.

**If it ever stops working** (error: *"401 / authentication failed"*):

- Just redo the device login: **MODELS → re-authenticate** (or run `hermes model`),
  then **↻ Restart Gateway**.

> ⚠️ **Important Codex limitation:** the login gets **kicked out** whenever that
> same ChatGPT account signs into Codex **anywhere else** (the ChatGPT app, VS Code,
> Codex CLI…). When that happens the assistant stops replying until you re-login.
> To avoid the constant re-login:
> - **Dedicate that ChatGPT account to Hermes only** (don't use it for Codex
>   elsewhere), **or**
> - **Use Path A (an API key)** — it never gets kicked out and is usually cheaper
>   for an always-on bot.

✅ **Your assistant now has a brain and works.** Try chatting in the dashboard
**CHAT** tab. Next, connect Telegram/WhatsApp so you can use it from your phone.

---

## 8. Connect Telegram

### 🔧 Get a bot token

1. In Telegram, search **@BotFather** → open it → send `/newbot`.
2. Give it a **display name** and a **username ending in `bot`**.
3. It replies with a **token** like `123456789:ABC...` — copy it (keep secret).

### 🔧 Get YOUR numeric ID

1. In Telegram, search **@userinfobot** → open it → press **Start**.
2. It replies with `Id: 123456789` — copy that **number**.

> This is **your** ID — not the bot's, not your @username.

### Set it up

You only need to tell Hermes two things — your **bot token** and your **numeric
ID** — then restart. Pick **any one** of these methods:

**Method 1 — Ask the assistant in the dashboard CHAT** *(easiest if the CHAT works)*

1. Open the dashboard → **CHAT** tab.
2. Type a message to the assistant like this (paste your real token + your number):
   > Set up the Telegram channel for me. Run these two commands, then restart the
   > gateway:
   > `hermes config set TELEGRAM_BOT_TOKEN 123456789:ABCdef...`
   > `hermes config set TELEGRAM_ALLOWED_USERS 123456789`
3. The assistant runs them inside its own container and restarts the gateway.

> ⚠️ If the CHAT shows **"[session ended]"** (e.g. you're on Cloudflare **WARP**),
> the dashboard chat can't run — use **Method 2 or 3** instead.

**Method 2 — Railway Variables** *(all browser, no chat/terminal needed)*

On the **`agentpoh`** service → **Variables**, add:

| Variable | Value |
|---|---|
| `TELEGRAM_BOT_TOKEN` | `123456789:ABCdef...` |
| `TELEGRAM_ALLOWED_USERS` | `123456789` *(your numeric ID; comma-separate for more people)* |

Save — Railway restarts the service automatically.

**Method 3 — Container shell** *(the interactive wizard)*

```bash
hermes gateway setup        # choose Telegram → paste token → paste your number
hermes gateway restart
```

---

Once set up by any method, **message your bot in Telegram — it should reply.** ✅

> 👨‍👩‍👧 **To let someone else in** (e.g. your child): get *their* number the same
> way and put **everyone's** numbers in `TELEGRAM_ALLOWED_USERS` as one
> comma-separated list (e.g. `123456789,987654321`), then restart the gateway.

---

## 9. Connect WhatsApp

Uses an **unofficial bridge** (it pairs like "WhatsApp Web").

> ⚠️ **Strongly recommended: use a SEPARATE phone number for the bot** — a spare
> SIM or a second number, **not your personal WhatsApp**. Why:
> - There's a **small risk WhatsApp bans the number** for automated use.
> - Pairing links the bot as a **device on that account**, so you don't want it
>   tied to your main personal number.
>
> A cheap prepaid SIM or any spare number works well.

WhatsApp setup has **two parts**: **(A)** pair the bot's phone by scanning a QR
code, and **(B)** set who's allowed.

### Part A — Pair the bot's phone (scan a QR)

The QR code can only be shown by running a command **live**, so use **one** of these:

**Method 1 — Ask the assistant in the dashboard CHAT** *(if the CHAT works)*

- Open the dashboard → **CHAT** → type:
  > Run `hermes whatsapp` in **bot** mode and show me the QR code so I can scan it.
- The assistant runs it and shows the QR (as text). *(⚠️ If CHAT shows
  "[session ended]" / you're on Cloudflare **WARP**, use Method 2.)*

**Method 2 — Container shell** *(most reliable)*

```bash
hermes whatsapp        # choose bot mode → a QR code prints in the terminal
```

**Then, on the BOT's phone:** WhatsApp → **Settings → Linked Devices → Link a
Device** → **scan the QR**. *(It refreshes every ~20 seconds — scan quickly.)*

> ❌ **No "Railway Variables" option for this part** — you can't paste a QR scan.
> Pairing always needs the live QR (Method 1 or 2).

### Part B — Set who's allowed

Set these three settings using **any** method (country code, **no `+`**):

```
WHATSAPP_ENABLED=true
WHATSAPP_MODE=bot
WHATSAPP_ALLOWED_USERS=6591234567
```

- **Railway Variables** *(all browser)*: `agentpoh` → **Variables** → add the three → Save.
- **Dashboard CHAT / shell:** `hermes config set WHATSAPP_ENABLED true` (and the same
  for `WHATSAPP_MODE bot` and `WHATSAPP_ALLOWED_USERS 6591234567`).

### Finish

Click **↻ Restart Gateway**, then **message the bot's number** — it should reply. ✅

> 👨‍👩‍👧 **To add more people:** put everyone's number in `WHATSAPP_ALLOWED_USERS`
> as one comma-separated list (e.g. `6591234567,6598765432`) and restart the
> gateway. They just message the **same bot number** — no pairing needed on their
> side.

> 🛟 **If WhatsApp types but no reply arrives:** **delete the chat with the bot and
> start a fresh one.** (WhatsApp changed how it identifies you — "@lid"; a new chat
> fixes it instantly.) Keep the bot phone online and don't link that account
> elsewhere.

---

## 10. Lock the front door (password + IP) — recommended

> 🔒 **Optional, but strongly recommended.** Right now the dashboard link from
> Step 6 is **public with no password** — anyone who gets the link could open your
> assistant (it holds your keys and can run commands). Skip this only for a quick
> throwaway test; for anything you keep using, **do it.**

### What we're building (the idea)

We put a small **guard** in front of your assistant — a second tiny service called
**`edge`** — and then **hide the assistant** so it has no public door of its own.
Before letting anyone through, the guard checks **two things**:

1. **Is your IP allowed?** *(IP allowlist)* — only **your** internet address(es) can
   even reach it. Everyone else gets **Forbidden**.
2. **Do you know the password?** *(login)* — even from an allowed IP, you must enter
   the correct password.

Only when **both** pass does the guard forward you — over Railway's **private
network** — to the assistant. Two layers means that if one ever slips, the other
still protects you.

```
                    [ IP not in your list?  -> Forbidden ]
  You  -->  edge ---[
(browser) (guard)   [ wrong password?       -> blocked   ]
                            | both pass
                            v  (private network)
                    agentpoh  (your assistant - no public door)
```

**The two pieces you'll create:**
- **A password** (stored as a scrambled "hash") → step 10.1
- **Your allowed IP** → step 10.2

…then you build the guard, point it at the assistant, test it, and finally remove
the assistant's public link.

> 🛡️ **Do the sub-steps in order** so you never lock yourself out — build & test the
> guard *first* (10.1–10.6), then hide the assistant *last* (10.7).

### 10.1 Generate your password hash

Your password is stored "scrambled" (a one-way **hash**), never in plain text.

- **Mac/Linux Terminal** — pick a username (`admin`) and your own password:
  ```bash
  htpasswd -nbB admin 'YourPasswordHere'
  ```
  It prints `admin:$2y$...`. **Copy everything after `admin:`** — that's your hash.
  Save the real password in your password manager.
- **Have Docker instead?**
  ```bash
  docker run --rm caddy:2-alpine caddy hash-password --plaintext 'YourPasswordHere'
  ```

### 10.2 Find your IP

1. Visit **https://ifconfig.me** (or Google "what is my IP").
2. Copy the number (e.g. `203.0.113.5`) and write it as **`203.0.113.5/32`**.

> ℹ️ Home IPs can change. If you ever get **"Forbidden"**, redo this and update the
> value.

### 10.3 Build the guard (`edge`)

1. Railway → **New → GitHub Repo →** pick the **same `agentpoh` repo** again.
2. **Settings → Rename** it to **`edge`**.
3. **Settings → Root Directory →** set to **`edge`** → Save.

> This makes the new service build the **guard**, not the assistant.

### 10.4 Set the guard's variables

On the `edge` service → **Variables**:

| Variable | Value |
|----------|-------|
| `HERMES_UPSTREAM` | `agentpoh.railway.internal:9119` *(your assistant's service name)* |
| `ALLOWED_IPS` | your IP, e.g. `203.0.113.5/32` *(space-separate to add more)* |
| `BASIC_AUTH_USER` | `admin` |
| `BASIC_AUTH_HASH` | *(the `$2y$...` hash from 10.1 — paste exactly, keep every `$`)* |

### 10.5 Give the guard a public address

`edge` → **Settings → Networking → Generate Domain.** This new link is your
**protected entrance**.

### 10.6 Test it

- Open the edge link → it should **ask for your password** → then show the
  dashboard. ✅
- Open it from a **different location** (phone on mobile data, Wi-Fi off) → it
  should say **Forbidden**. ✅

### 10.7 Hide the assistant *(do this LAST)*

On `agentpoh` → **Settings → Networking → remove the public domain** (the temporary
link from Step 6).

✅ Now the assistant has no public door — it's reachable **only** through the guard.

---

## 11. Read protected websites — optional

> 🌐 **Use-case add-on.** Do this **only if** you want your assistant to **browse
> the web for you** — e.g. check a forum or page for updates and summarise them. If
> you just want a chat assistant, you can **skip this entirely**.

Many sites (e.g. forums behind **Cloudflare**) block normal automated reading. To
let your assistant read them reliably, give it a **cloud browser** — **Browserbase**
is a good, recommended way to start.

### 🔧 Get Browserbase keys

1. Sign up at https://browserbase.com (the **free tier** is enough to start).
2. From the dashboard, copy your **API Key** and **Project ID**.

### Add them

1. Dashboard **KEYS**, or ask the assistant to run *(note the space, not `=`)*:
   ```bash
   hermes config set BROWSERBASE_API_KEY <your key>
   hermes config set BROWSERBASE_PROJECT_ID <your id>
   ```
2. Make sure **Browser Automation** is on (dashboard **CONFIG**), then **↻ Restart
   Gateway**.

### Try it

Ask your assistant (Telegram or dashboard) to read a page — e.g. *"Open
example.com and tell me the main heading."*

> A site showing **"Just a moment…"** often **clears if the browser waits ~25
> seconds**. If it stays blocked, the site is actively refusing bots — respect
> that; keep requests slow, minimal, and only for public info.

---

## ✅ How to use it day-to-day

- **Chat:** Telegram (most reliable), WhatsApp, or the dashboard **CHAT**.
- **Open the dashboard:** your **edge** link + your password *(if you locked it down
  in Step 10)* — otherwise the temporary Railway link from Step 6.
- **Restart:** dashboard → **↻ Restart Gateway**.
- **Change settings/keys:** dashboard → **CONFIG** / **KEYS**.
- **See its memory:** dashboard → **PROFILES**, **SESSIONS**, **SKILLS**.
- **Update the setup:** change files in your GitHub repo → Railway rebuilds.

> 🔑 **No Terminal needed for most things.** If a task needs a command, just **ask
> the assistant to run it**, e.g. *"Run `hermes --version` and show me the output."*

---

## 🛠️ Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| No reply; logs show **HTTP 401 / token_invalidated** | Codex/ChatGPT login kicked out (signed in elsewhere) | Re-login (**MODELS → re-authenticate**); don't reuse that account for Codex elsewhere. Best fix: switch to an **API key**. |
| **Web chat** shows "session ended / events feed disconnected" | The in-browser chat is flaky over the cloud (and **WARP** blocks its WebSocket) | Use **Telegram** instead — it's not a real fault. |
| **WhatsApp** types then nothing arrives | WhatsApp changed your ID ("@lid") | **Delete the bot chat, start a new one.** |
| **Edge shows 502** | Wrong name in `HERMES_UPSTREAM` | Use your real assistant name: `agentpoh.railway.internal:9119`. |
| **Website blocked** ("Just a moment…") | Cloudflare bot check | Let the browser **wait ~25s**; if still blocked, the site refuses bots. |
| **Public site went down** after a network change | A listen-address change made too early | Keep the known-good setting until the guard is ready. |
| **`railway ssh` fails** ("invalid peer certificate") | Network **Cloudflare WARP** inspects traffic; the Railway CLI rejects it | Don't use the CLI — **ask the assistant to run commands** and use the **dashboards** (browser works fine). For QR-pairing, use a **personal device without WARP**. |

---

## 📋 Quick reference

| Thing | Value (example) |
|------|-------|
| Assistant service | `agentpoh` *(goes private after you lock down in Step 10)* |
| Guard service | `edge` *(public entrance — only if you did Step 10)* |
| Storage path | `/opt/data` |
| Dashboard port (internal) | `9119` |
| Guard forwards to | `agentpoh.railway.internal:9119` |
| Model | API key (Claude/GPT) or Codex |
| Channels | Telegram + WhatsApp |
| Web reading | Browserbase |

> 🔒 **Never put real secrets in GitHub or this file.** The password, API keys,
> Telegram token, and WhatsApp session live only in Railway / `/opt/data`.

---

## 📖 Glossary

| Term | Meaning |
|---|---|
| **Railway** | Cloud service that runs your always-on machine. |
| **Hermes Agent** | The AI assistant software. |
| **Model / brain** | The AI (Claude, GPT, Codex) that writes the replies. |
| **API key** | Pay-as-you-go access to an AI (not a subscription); a secret like `sk-...`. |
| **Volume** | Permanent storage that survives restarts (`/opt/data`). |
| **Edge / guard** | The gatekeeper checking password + IP before letting you in. |
| **IP** | Your internet "address"; the allow-list restricts who can connect. |
| **Hash** | A scrambled, one-way version of your password (safe to store). |
| **Fork** | Your own personal copy of a GitHub project (only needed if the repo isn't yours). |
| **Terminal** | A window for typing commands (Mac: Terminal; Windows: PowerShell). |
| **Gateway** | The part of Hermes that connects Telegram/WhatsApp. |
| **Browserbase** | A cloud browser that lets the assistant read web pages. |
| **WARP** | Cloudflare's network tool (often on work laptops) that can break the Railway CLI. |
| **@lid** | WhatsApp's newer private ID; if it changes, start a fresh chat. |
