# Secrets Configuration Guide

This application now uses **Rails encrypted credentials** (the modern approach introduced in Rails 5.2+).

## How It Works

**Files:**
- `config/credentials.yml.enc` - Encrypted credentials file (safe to commit to git)
- `config/master.key` - 32-character decryption key (**NEVER commit this!**)

The `master.key` is used to decrypt the encrypted credentials file. This is much more secure than storing secrets in plain text.

## Required GitHub Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### For CI/CD to Work:

#### 1. RAILS_MASTER_KEY (Required)
```
Name: RAILS_MASTER_KEY
Value: <paste the content of your config/master.key file>
```

**To get your master key:**
```bash
cat config/master.key
```

⚠️ **CRITICAL:** Keep this key secret! Anyone with this key can decrypt your credentials.
⚠️ **NEVER** commit config/master.key to git or share it publicly!

#### 2. Deployment Platform Secrets

**For Fly.io:**
```
Name: FLY_API_TOKEN
Value: <get from: fly auth token>
```

**For Railway:**
```
Name: RAILWAY_TOKEN
Value: <get from: railway.app/account/tokens>
```

**For Render:**
```
Name: RENDER_API_KEY
Value: <get from render.com dashboard>

Name: RENDER_SERVICE_ID
Value: <get from your service URL>
```

## Viewing/Editing Credentials

### View Credentials (Decrypted)
```bash
EDITOR=cat rails credentials:show
```

### Edit Credentials
```bash
EDITOR=nano rails credentials:edit
```

This will decrypt, open in nano, and re-encrypt on save.

### Current Credentials Structure
```yaml
secret_key_base: <your-secret-key>

smtp:
  address: mail.garyandstephanie.com
  port: 25
  username: wedding@garyandstephanie.com
  password: <smtp-password>
  authentication: plain

mailer:
  host: garyandstephanie.com
```

## Deployment Platform Setup

Each platform needs the `RAILS_MASTER_KEY` environment variable to decrypt credentials in production.

### Fly.io

```bash
# Set the master key
fly secrets set RAILS_MASTER_KEY=$(cat config/master.key)

# Verify it's set
fly secrets list
```

### Railway

1. Go to your Railway project
2. Click on "Variables" tab
3. Add new variable:
   - Key: `RAILS_MASTER_KEY`
   - Value: (paste content of config/master.key)

### Render

1. Go to your Render dashboard
2. Select your web service
3. Go to "Environment" tab
4. Add environment variable:
   - Key: `RAILS_MASTER_KEY`
   - Value: (paste content of config/master.key)

## Security Best Practices

### ✅ DO:
- Keep `config/master.key` in `.gitignore` (already configured)
- Store `RAILS_MASTER_KEY` in GitHub Secrets
- Set `RAILS_MASTER_KEY` as environment variable on deployment platforms
- Rotate your master key if it's ever compromised
- Back up your master key in a secure password manager

### ❌ DON'T:
- Never commit `config/master.key` to git
- Never share your master key publicly
- Never hardcode secrets in your application code
- Never send the master key via email or chat

## Troubleshooting

### "Missing encryption key" error

**In development:**
```bash
# Make sure config/master.key exists
ls -la config/master.key

# If missing, you can't decrypt credentials without the key
# Contact someone on the team who has it
```

**In production:**
```bash
# Check if RAILS_MASTER_KEY is set
fly secrets list  # for Fly.io

# If not set, add it:
fly secrets set RAILS_MASTER_KEY=<your-key>
```

### "ActiveSupport::MessageEncryptor::InvalidMessage" error

This means the master key doesn't match the encrypted credentials file.

**Solution:**
1. Make sure you're using the correct master key
2. Or regenerate credentials with a new key (will lose existing credentials)

### Need to regenerate everything?

```bash
# Delete old files
rm config/credentials.yml.enc config/master.key

# Create new credentials
EDITOR=nano rails credentials:edit

# This creates new credentials.yml.enc and master.key
# Add your secrets, save, and exit
```

## Migrating SMTP Password

If you need to update the SMTP password:

```bash
# Edit credentials
EDITOR=nano rails credentials:edit

# Update the smtp.password value
# Save and exit

# Redeploy to production
git push  # triggers CI/CD
```

No need to update environment variables on the deployment platform!

## What's Stored in Credentials

Currently stored:
- ✅ `secret_key_base` - Rails session encryption key
- ✅ `smtp.*` - Email server configuration
- ✅ `mailer.host` - Email link host

You can add more:
- API keys (Stripe, AWS, etc.)
- Third-party service credentials
- Any other sensitive configuration

## Advantages of This Approach

✅ **Secure:** Secrets are encrypted at rest
✅ **Version controlled:** Encrypted file can be committed safely
✅ **Centralized:** All secrets in one place
✅ **Standard:** Rails best practice since 5.2
✅ **Team-friendly:** Each environment can have different keys

## Quick Reference

| Task | Command |
|------|---------|
| View credentials | `EDITOR=cat rails credentials:show` |
| Edit credentials | `EDITOR=nano rails credentials:edit` |
| Get master key | `cat config/master.key` |
| Set on Fly.io | `fly secrets set RAILS_MASTER_KEY=$(cat config/master.key)` |
| Set on Railway | Add in Variables tab |
| Set on Render | Add in Environment tab |

---

**🎉 You're now using modern Rails encrypted credentials!**
