# 🚀 Fly.io Deployment - Quick Start Guide

Follow these steps **exactly** to deploy your wedding website to Fly.io in ~15 minutes.

---

## ⏱️ Time Estimate: 15 minutes

- ✅ Step 1-2: Install tools (2 min)
- ✅ Step 3-5: Configure app (3 min)
- ✅ Step 6: First deployment (5 min)
- ✅ Step 7: Verification (2 min)
- ✅ Step 8: Final setup (3 min)

---

## 📋 Prerequisites

- [x] Git repository cloned locally
- [x] This PR merged to master
- [x] Terminal/command line access
- [x] Web browser

---

## 🔧 Step 1: Install Fly CLI

Copy and paste this command:

```bash
curl -L https://fly.io/install.sh | sh
```

**Expected output:** "fly was installed successfully"

Add to your PATH (paste into terminal):

```bash
export PATH="$HOME/.fly/bin:$PATH"
```

Verify installation:

```bash
fly version
```

**Expected output:** Something like "fly v0.x.xxx"

✅ **Checkpoint:** You should see a version number.

---

## 🔑 Step 2: Login to Fly.io

```bash
fly auth login
```

**What happens:** Browser opens to Fly.io login page.

**Actions:**
1. Sign up for Fly.io account (free)
2. Or log in if you have an account
3. Return to terminal when done

✅ **Checkpoint:** Terminal shows "successfully logged in"

---

## 📂 Step 3: Navigate to Project

```bash
cd /path/to/garyandstephaniewedding
```

Replace `/path/to/` with your actual path.

Verify you're in the right place:

```bash
ls fly.toml
```

**Expected output:** Should show `fly.toml` exists.

✅ **Checkpoint:** `fly.toml` file exists.

---

## 🚀 Step 4: Launch the App

```bash
fly launch
```

**Answer the prompts:**

```
? Choose an app name: gary-stephanie-wedding
  (or press Enter to get a random name)

? Choose a region for deployment:
  → Select the closest region to you:
    - iad (US East - Virginia)
    - lax (US West - Los Angeles)
    - ord (US Central - Chicago)
    - Use arrow keys, then press Enter

? Would you like to set up a Postgresql database?
  → Type: n [Enter]

? Would you like to set up an Upstash Redis database?
  → Type: n [Enter]

? Would you like to deploy now?
  → Type: n [Enter]
```

**Expected output:** "Wrote config file fly.toml"

✅ **Checkpoint:** Command completes without errors.

---

## 💾 Step 5: Create Persistent Volume

**Important:** Use the SAME region you selected in Step 4!

```bash
fly volumes create sqlite_data --size 1 --region iad
```

Replace `iad` with your chosen region.

**Expected output:** "volume vol_xxx created"

Verify volume exists:

```bash
fly volumes list
```

**Expected output:**
```
ID          NAME            SIZE    REGION
vol_xxx     sqlite_data     1GB     iad
```

✅ **Checkpoint:** Volume appears in list.

---

## 🔐 Step 6: Set Master Key Secret

**First, get your master key:**

```bash
cat config/master.key
```

**Expected output:** A 32-character string like: `3a2b4c5d6e7f...`

**Copy this output!**

Now set it as a secret:

```bash
fly secrets set RAILS_MASTER_KEY=<paste-your-key-here>
```

**Example:**
```bash
fly secrets set RAILS_MASTER_KEY=3a2b4c5d6e7f8g9h0i1j2k3l4m5n6o7p
```

**Expected output:** "Setting secrets on gary-stephanie-wedding"

Verify secret is set:

```bash
fly secrets list
```

**Expected output:**
```
NAME                DIGEST          CREATED AT
RAILS_MASTER_KEY    xxxxx           just now
```

✅ **Checkpoint:** Secret appears in list (digest only, not actual value).

---

## 🎉 Step 7: Deploy!

This is the big moment:

```bash
fly deploy
```

**What happens:**
1. Builds Docker image (2-3 min)
2. Installs dependencies
3. Precompiles assets
4. Pushes to Fly.io
5. Starts your app

**Expected output (last lines):**
```
--> v0 deployed successfully
```

**⏱️ This takes 3-5 minutes on first deploy.**

✅ **Checkpoint:** Deploy completes successfully.

---

## ✅ Step 8: Verify Deployment

Check app status:

```bash
fly status
```

**Expected output:**
```
App
  Name     = gary-stephanie-wedding
  Status   = running

Machines
ID      STATE   REGION  CHECKS
xxx     started iad     3 passing
```

Open your website:

```bash
fly open
```

**What happens:** Browser opens to your wedding website!

**Expected:** You should see your wedding website homepage.

✅ **Checkpoint:** Website loads in browser.

---

## 🔍 Step 9: Test Everything Works

### Test 1: Check Database

```bash
fly ssh console -C "bundle exec rails runner 'puts User.count'"
```

**Expected output:** A number (count of users).

### Test 2: Check Credentials Decrypt

```bash
fly ssh console -C "bundle exec rails runner 'puts Rails.application.credentials.smtp[:address]'"
```

**Expected output:** `mail.garyandstephanie.com`

### Test 3: View Logs

```bash
fly logs
```

**Expected output:** Recent application logs.

Press `Ctrl+C` to exit.

✅ **Checkpoint:** All tests pass.

---

## 🎊 Success! Your Site is Live!

### Your wedding website is now:

✅ **Live** at: https://gary-stephanie-wedding.fly.dev
✅ **Secure** with automatic HTTPS
✅ **Persistent** - data survives restarts
✅ **Free** - within Fly.io free tier
✅ **Monitored** - check with `fly logs`

---

## 📝 Post-Deployment Checklist

### Required:

- [ ] Add `RAILS_MASTER_KEY` to GitHub Secrets
  ```
  Go to: Repository → Settings → Secrets → Actions
  Add: RAILS_MASTER_KEY = <your-key-from-config-master.key>
  ```

- [ ] Test RSVP functionality on live site
  - Visit website
  - Try logging in as a user
  - Submit an RSVP
  - Verify it saves

- [ ] Rotate SMTP password (see `SECURITY.md`)
  - Old password is in git history
  - Update your email provider
  - Update encrypted credentials
  - Redeploy

### Optional:

- [ ] Set up custom domain (see `DEPLOYMENT.md`)
- [ ] Add team members to Fly.io app
- [ ] Set up monitoring alerts
- [ ] Configure backups

---

## 🆘 Troubleshooting

### Problem: "fly: command not found"

**Solution:**
```bash
export PATH="$HOME/.fly/bin:$PATH"
# Add this to ~/.bashrc or ~/.zshrc for permanence
```

### Problem: "Missing encryption key"

**Solution:**
```bash
# Verify secret is set
fly secrets list

# If missing, set it again
fly secrets set RAILS_MASTER_KEY=<your-key>
```

### Problem: App won't start

**Solution:**
```bash
# Check logs for errors
fly logs

# Common fixes:
# 1. Verify RAILS_MASTER_KEY is set
# 2. Check volume is mounted: fly volumes list
# 3. Restart: fly apps restart gary-stephanie-wedding
```

### Problem: Database connection error

**Solution:**
```bash
# Verify volume is mounted
fly ssh console -C "ls -la /data"

# Should show: production.sqlite3

# If missing, volume may not be attached
fly volumes list
# Then check fly.toml has correct mount configuration
```

### Problem: Can't access website

**Solution:**
```bash
# Check app status
fly status

# If not running, check logs
fly logs

# Restart if needed
fly apps restart gary-stephanie-wedding
```

---

## 🔄 Making Updates

### Deploy Code Changes:

```bash
# 1. Make your changes locally
# 2. Commit to git
git add .
git commit -m "Your changes"
git push

# 3. Deploy
fly deploy
```

### Update Secrets:

```bash
# Update a secret
fly secrets set RAILS_MASTER_KEY=new-key

# Or update credentials file
EDITOR=nano rails credentials:edit
# Make changes, save
fly deploy
```

### View Recent Deployments:

```bash
fly releases
```

---

## 📊 Monitoring & Management

### Check App Status:
```bash
fly status
```

### View Logs (real-time):
```bash
fly logs -f
```

### Open Rails Console:
```bash
fly ssh console
bundle exec rails console
```

### Check Resource Usage:
```bash
fly dashboard
```

Opens web dashboard in browser.

---

## 💰 Cost Monitoring

### Free Tier Includes:
- 3 shared-cpu VMs (you use 1)
- 3GB persistent storage (you use 1GB)
- 160GB transfer/month

### Check Current Usage:
```bash
fly dashboard
```

Go to: Billing → Usage

**Your wedding website should stay FREE!** 🎉

---

## 📞 Getting Help

### Documentation:
- Complete guide: `DEPLOYMENT.md`
- Secrets setup: `.github/SECRETS_SETUP.md`
- Troubleshooting: `DEPLOYMENT.md` (troubleshooting section)

### Fly.io Resources:
- Docs: https://fly.io/docs/
- Community: https://community.fly.io/
- Status: https://status.fly.io/

### Quick Commands:
```bash
fly status          # App status
fly logs            # View logs
fly ssh console     # SSH into app
fly dashboard       # Open web dashboard
fly help            # List all commands
```

---

## ✅ Completion Checklist

Deployment complete when:

- [x] Step 1-9 completed successfully
- [x] Website loads in browser
- [x] All verification tests pass
- [x] `fly status` shows "running"
- [x] Can view logs with `fly logs`

Post-deployment complete when:

- [ ] GitHub Secret added (RAILS_MASTER_KEY)
- [ ] RSVP tested on live site
- [ ] SMTP password rotated (if needed)

---

## 🎉 Congratulations!

Your wedding website is now live and ready for guests! 💒

**Share your URL:**
```
https://gary-stephanie-wedding.fly.dev
```

(Or your custom domain if configured)

---

## 🚀 Quick Reference Card

Save these commands:

```bash
# Deploy updates
fly deploy

# View logs
fly logs

# Check status
fly status

# Open website
fly open

# SSH into app
fly ssh console

# Restart app
fly apps restart gary-stephanie-wedding

# View secrets (digests only)
fly secrets list

# Rails console
fly ssh console -C "bundle exec rails console"
```

---

**That's it! You're done!** 🎊

Need more details? See `DEPLOYMENT.md` for comprehensive documentation.
