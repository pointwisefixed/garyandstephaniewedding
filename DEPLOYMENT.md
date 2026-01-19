# 🚀 Fly.io Deployment Guide

Complete guide to deploy the wedding website to Fly.io.

---

## 📋 Required Environment Variables

### ONE Secret Required: RAILS_MASTER_KEY

This is the **ONLY** environment variable you need to set. All other secrets (SMTP password, secret_key_base, etc.) are encrypted in `config/credentials.yml.enc` and will be automatically decrypted using this key.

**Get your Master Key:**
```bash
cat config/master.key
```

⚠️ **CRITICAL:**
- Keep this key secret! Store it in a password manager.
- NEVER commit config/master.key to git
- NEVER share it publicly or in documentation

---

## 🔧 Deployment Steps

### Prerequisites

1. **Install Fly CLI**
   ```bash
   curl -L https://fly.io/install.sh | sh

   # Add to PATH (add to ~/.bashrc or ~/.zshrc)
   export PATH="$HOME/.fly/bin:$PATH"

   # Verify installation
   fly version
   ```

2. **Login to Fly.io**
   ```bash
   fly auth login
   ```

### Step-by-Step Deployment

#### 1. Launch the App

```bash
# Navigate to project directory
cd /path/to/garyandstephaniewedding

# Launch app (interactive setup)
fly launch

# When prompted:
# - App name: gary-stephanie-wedding (or your choice)
# - Region: Choose closest to you (e.g., iad, lax, ord)
# - PostgreSQL: NO (we use SQLite)
# - Redis: NO (not needed)
# - Deploy now: NO (we need to set secrets first)
```

This creates/updates your `fly.toml` configuration file.

#### 2. Create Persistent Volume for SQLite

```bash
# Create a 1GB volume for the database
# Use the SAME region you chose in step 1
fly volumes create sqlite_data --size 1 --region iad

# Verify volume was created
fly volumes list
```

#### 3. Set the Master Key Secret

```bash
# Set the RAILS_MASTER_KEY secret
fly secrets set RAILS_MASTER_KEY=<your-master-key-from-config-master.key>

# Verify it's set (shows digest, not actual value)
fly secrets list
```

**Expected output:**
```
NAME                DIGEST          CREATED AT
RAILS_MASTER_KEY    <digest>        just now
```

#### 4. Deploy the Application

```bash
# Deploy to Fly.io
fly deploy

# This will:
# - Build Docker image
# - Install dependencies
# - Precompile assets
# - Push to Fly.io
# - Start the app
```

**First deployment takes 3-5 minutes.**

#### 5. Run Database Migrations

```bash
# The entrypoint script runs db:prepare automatically
# But you can manually migrate if needed:
fly ssh console -C "bundle exec rails db:migrate"
```

#### 6. Open Your App! 🎉

```bash
fly open
```

Your wedding website is now live!

---

## 🔍 Verification & Monitoring

### Check App Status
```bash
fly status
```

**Expected output:**
```
App
  Name     = gary-stephanie-wedding
  Owner    = your-org
  Hostname = gary-stephanie-wedding.fly.dev
  Platform = machines

Machines
ID              STATE   REGION  HEALTH CHECKS   IMAGE
abc123          started iad     3 total, 3 passing
```

### View Real-Time Logs
```bash
fly logs
```

### Check Secrets
```bash
fly secrets list
```

### Test Credentials Decryption
```bash
fly ssh console -C "bundle exec rails runner 'puts Rails.application.credentials.smtp[:address]'"
```

**Expected output:** `mail.garyandstephanie.com`

### Open Rails Console
```bash
fly ssh console
bundle exec rails console
```

---

## 📊 What Gets Deployed

### From Your Repository
- ✅ Application code (controllers, models, views)
- ✅ Gemfile and dependencies
- ✅ Database schema and migrations
- ✅ Assets (CSS, JavaScript, images)
- ✅ Encrypted credentials file (config/credentials.yml.enc)

### NOT Deployed (Excluded by .dockerignore)
- ❌ config/master.key (secret, set via fly secrets)
- ❌ .env files
- ❌ Development dependencies
- ❌ Test files
- ❌ Log files
- ❌ .git directory

### From Fly.io
- ✅ RAILS_MASTER_KEY (decrypts credentials.yml.enc)

---

## 🔄 Updating Your App

### Deploy Code Changes
```bash
git push origin main  # or your branch
fly deploy
```

### Update Secrets
```bash
# Update master key (if rotated)
fly secrets set RAILS_MASTER_KEY=new-key-here

# Update SMTP password (edit encrypted credentials)
EDITOR=nano rails credentials:edit
# Save changes, then deploy
fly deploy
```

### Run New Migrations
```bash
fly ssh console -C "bundle exec rails db:migrate"
```

### Restart App
```bash
fly apps restart gary-stephanie-wedding
```

---

## 🎛️ Scaling & Configuration

### View Current Resources
```bash
fly status
```

### Scale Memory (if needed)
```bash
# Upgrade to 512MB (still in free tier)
fly scale memory 512

# Scale to 1GB
fly scale memory 1024
```

### Scale Machine Count
```bash
# Add more machines for high availability
fly scale count 2

# Scale back to 1
fly scale count 1
```

### Change Region
```bash
# List available regions
fly platform regions

# Deploy to additional region
fly regions add lax
```

---

## 💰 Cost Estimation

### Free Tier (Your Wedding Site Will Likely Fit)
- ✅ 3 shared-cpu VMs with 256MB RAM each
- ✅ 3GB persistent volumes
- ✅ 160GB outbound data transfer/month

**Your Usage:**
- 1 VM (256MB) = **Free**
- 1GB volume = **Free**
- Low traffic = **Free**

### If You Exceed Free Tier
- Shared CPU VMs: ~$1.94/month per VM
- Persistent volumes: ~$0.15/GB/month
- Outbound transfer: $0.02/GB (after 160GB)

**Estimate:** Your wedding website should stay **100% free** with normal traffic.

---

## 🆘 Troubleshooting

### "Missing encryption key" Error

**Problem:** App can't decrypt credentials

**Solution:**
```bash
# Check if RAILS_MASTER_KEY is set
fly secrets list

# If missing, set it
fly secrets set RAILS_MASTER_KEY=<your-master-key-from-config-master.key>
```

### Database Connection Error

**Problem:** Can't connect to database

**Solution:**
```bash
# Check if volume is mounted
fly ssh console -C "ls -la /data"

# Check database configuration
fly ssh console -C "bundle exec rails runner 'puts ActiveRecord::Base.connection_db_config.database'"

# Should output: /data/production.sqlite3
```

### App Won't Start

**Problem:** Deployment succeeds but app crashes

**Solution:**
```bash
# Check logs for errors
fly logs

# Common issues:
# 1. Missing RAILS_MASTER_KEY → Set with fly secrets set
# 2. Asset precompilation failed → Check Dockerfile
# 3. Database migration needed → Run fly ssh console -C "rails db:migrate"
```

### Can't Send Emails

**Problem:** SMTP not working

**Solution:**
```bash
# Verify credentials decrypt properly
fly ssh console -C "bundle exec rails runner 'p Rails.application.credentials.smtp'"

# If password is wrong (old one from git history), update it:
EDITOR=nano rails credentials:edit
# Update smtp.password
# Save and redeploy
fly deploy
```

### Volume Full

**Problem:** SQLite database out of space

**Solution:**
```bash
# Check volume usage
fly ssh console -C "df -h /data"

# Extend volume if needed
fly volumes extend <volume-id> --size 2
```

---

## 🔐 Security Checklist

Before going live, verify:

- [x] `RAILS_MASTER_KEY` is set on Fly.io
- [x] `config/master.key` is NOT in git (check .gitignore)
- [x] Force HTTPS is enabled (check fly.toml)
- [x] Database is on persistent volume (not ephemeral)
- [x] SMTP password has been rotated (if using old one)
- [x] Assets are precompiled
- [x] No secrets in code or documentation

---

## 📱 Custom Domain (Optional)

### Add Your Own Domain

```bash
# Add custom domain
fly certs add garyandstephanie.com

# Add www subdomain
fly certs add www.garyandstephanie.com

# Get DNS instructions
fly certs show garyandstephanie.com
```

**Then add DNS records at your domain registrar:**
```
Type  Name  Value
A     @     fly.io IPv4 address
AAAA  @     fly.io IPv6 address
CNAME www   gary-stephanie-wedding.fly.dev
```

---

## 🎯 Quick Command Reference

```bash
# Deploy
fly deploy

# View logs
fly logs -f

# SSH into app
fly ssh console

# Rails console
fly ssh console -C "bundle exec rails console"

# Run migrations
fly ssh console -C "bundle exec rails db:migrate"

# Restart app
fly apps restart

# Check status
fly status

# List secrets
fly secrets list

# Set secret
fly secrets set KEY=value

# Open app in browser
fly open

# View dashboard
fly dashboard
```

---

## 🎉 Success!

Your wedding website is now deployed to Fly.io!

**App URL:** https://gary-stephanie-wedding.fly.dev

**What's Running:**
- Rails 7.2.3
- Ruby 3.3.6
- SQLite database (persistent)
- Encrypted credentials
- Automatic HTTPS
- Auto-scaling

**Next Steps:**
1. Share the URL with your guests
2. Test RSVP functionality
3. Monitor logs for any issues
4. Consider custom domain (optional)

---

## 📞 Support

- **Fly.io Docs:** https://fly.io/docs/
- **Fly.io Community:** https://community.fly.io/
- **App Status:** `fly status`
- **App Logs:** `fly logs`

---

**Deployed with ❤️ using Fly.io**
