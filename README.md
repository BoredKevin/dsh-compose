# dsh-compose

Run DeepSeek Harness (`@deepseek-ai/dsh`) remotely using docker compose, and proxy it using **Cloudflare Tunnel (`cloudflared`)**.

---

## Deployment Instructions

### 1. Configure Cloudflare Zero Trust (Host-Managed)

1. **In your host's Cloudflare Tunnel config or Dashboard:**
   - Route your target public hostname (e.g., `dsh.yourdomain.com`) to:
     - **Type:** `HTTP`
     - **URL:** `localhost:3080` (or `127.0.0.1:3080`)

2. **Protect with Cloudflare Access (Cloudflare One):**
   - In [Cloudflare Zero Trust](https://one.dash.cloudflare.com/), go to **Access** > **Applications** > **Add an application** > **Self-hosted**.
   - Set **Application Domain** to `dsh.yourdomain.com`.
   - Add an **Access Policy** (e.g., `Include: Emails` -> `your-email@example.com`).

---

### 2. Configure Environment

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Configure your domain in `.env`:
   ```dotenv
   DSH_TRUSTED_HOST=dsh.yourdomain.com
   DSH_PUBLIC_URL=https://dsh.yourdomain.com
   ```
   *(Note: You do not need to add your API key here; you will set it via the Web UI)*.

---

### 3. Start DeepSeek Harness

Build and run the container:
```bash
docker compose up -d --build
```

Check logs:
```bash
docker compose logs -f
```

---

### 4. Configure API Key in Web UI

1. Open your browser and navigate to `https://dsh.yourdomain.com`.
2. Authenticate through Cloudflare Zero Trust.
3. In the DeepSeek Harness interface, navigate to **Settings** > **Model Provider** / **API Keys**.
4. Paste your DeepSeek API key and save. The key is permanently saved to the mounted volume (`/home/node/.dsh`).
