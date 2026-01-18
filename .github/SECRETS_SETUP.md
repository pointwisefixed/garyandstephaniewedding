# Secrets Configuration Guide

This application uses the legacy Rails `config/secrets.yml` approach (from Rails 4.2) rather than the modern encrypted credentials system.

## Required GitHub Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### For CI/CD to Work:

#### 1. SECRET_KEY_BASE (Required for tests)
```
Name: SECRET_KEY_BASE
Value: 39bb45acf1e431fc5fb8ebbfb6cd9fe381290b9fe644cb1633ef081089273436b5e7a54f2cd6f4c54fc45370003566d6db2822101df23ae076c04ed3949898d3
```
This is the test secret from `config/secrets.yml`. It's safe to commit to GitHub Secrets.

#### 2. Production Secrets (Required for deployment)

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

#### 3. Email Configuration (Optional)

If you want emails to work in production:
```
Name: SMTP_ADDRESS
Value: mail.garyandstephanie.com

Name: SMTP_USERNAME
Value: wedding@garyandstephanie.com

Name: SMTP_PASSWORD
Value: <your-smtp-password>
```

## How Secrets Work in This App

### Development & Test
Secrets are read from `config/secrets.yml`:
```yaml
development:
  secret_key_base: <dev-secret>

test:
  secret_key_base: <test-secret>
```

### Production (Two Options)

**Option A: Use Environment Variable (Recommended)**

Set `SECRET_KEY_BASE` environment variable on your deployment platform:

**Fly.io:**
```bash
fly secrets set SECRET_KEY_BASE=452e71b269e3773a6b89a16f327e9520b2c23011978c7c24f80c9526831b23a447dd2c32eb3ee5fed4daf8b9f3f604f5080da7967b804921a98dfa0256d8679b
```

**Railway:**
Add in Railway dashboard → Variables:
```
SECRET_KEY_BASE=452e71b269e3773a6b89a16f327e9520b2c23011978c7c24f80c9526831b23a447dd2c32eb3ee5fed4daf8b9f3f604f5080da7967b804921a98dfa0256d8679b
```

**Render:**
Add in Render dashboard → Environment:
```
SECRET_KEY_BASE=452e71b269e3773a6b89a16f327e9520b2c23011978c7c24f80c9526831b23a447dd2c32eb3ee5fed4daf8b9f3f604f5080da7967b804921a98dfa0256d8679b
```

**Option B: Use secrets.yml**

Deploy `config/secrets.yml` with your app (already in the repo).

## Security Note

⚠️ **Your production secret key is currently in the public repository** (`config/secrets.yml`).

### To Improve Security:

1. **Generate a new production secret:**
   ```bash
   rails secret
   ```

2. **Update secrets.yml production section:**
   ```yaml
   production:
     secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
   ```

3. **Set the environment variable on your platform** (see commands above)

4. **Commit the change:**
   ```bash
   git add config/secrets.yml
   git commit -m "Use environment variable for production secret"
   git push
   ```

This way, your production secret is never in the repository.

## Migrating to Rails 7 Encrypted Credentials (Optional)

If you want to use the modern Rails approach:

```bash
# Generate credentials file
EDITOR=nano rails credentials:edit

# This creates:
# - config/credentials.yml.enc (encrypted, safe to commit)
# - config/master.key (keep secret, add to .gitignore)

# Then add to GitHub Secrets:
# RAILS_MASTER_KEY = <content of config/master.key>
```

But for this wedding website, the simpler secrets.yml approach is fine!

## Current Setup Summary

✅ **Development**: Uses hardcoded secret from secrets.yml
✅ **Test**: Uses hardcoded secret from secrets.yml
⚠️ **Production**: Uses hardcoded secret from secrets.yml (consider moving to ENV)

## Quick Reference: What to Add to GitHub Secrets

**Minimum (for tests to pass):**
```
SECRET_KEY_BASE = <test secret from secrets.yml>
```

**For deployment:**
```
FLY_API_TOKEN = <your fly.io token>
# or RAILWAY_TOKEN / RENDER_API_KEY depending on platform
```

**Optional (for emails):**
```
SMTP_PASSWORD = <your email password>
```

That's it! 🎉
