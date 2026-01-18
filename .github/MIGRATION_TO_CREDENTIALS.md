# Migration Guide: secrets.yml → Encrypted Credentials

This guide shows how to migrate from the legacy `config/secrets.yml` to modern Rails encrypted credentials.

## Current State (Old System)

**Files:**
- `config/secrets.yml` - Plain text secrets (in repo)

**Security:** ⚠️ Production secret is visible in repository

## Target State (Modern System)

**Files:**
- `config/credentials.yml.enc` - Encrypted secrets (safe to commit)
- `config/master.key` - Decryption key (never commit, in .gitignore)

**Security:** ✅ Production secrets are encrypted and safe

---

## Migration Steps

### Step 1: Generate Encrypted Credentials

```bash
# This creates config/credentials.yml.enc and config/master.key
EDITOR=nano rails credentials:edit
```

This will open an editor. Add:

```yaml
# config/credentials.yml.enc (will be encrypted)
secret_key_base: 452e71b269e3773a6b89a16f327e9520b2c23011978c7c24f80c9526831b23a447dd2c32eb3ee5fed4daf8b9f3f604f5080da7967b804921a98dfa0256d8679b

smtp:
  address: mail.garyandstephanie.com
  port: 25
  username: wedding@garyandstephanie.com
  password: YOUR_SMTP_PASSWORD
  authentication: plain

mailer:
  host: garyandstephanie.com
```

Save and exit (Ctrl+X, then Y, then Enter in nano).

### Step 2: Update Production Config

Edit `config/environments/production.rb`:

**Remove:**
```ruby
if ENV['SMTP_ADDRESS'].present?
  config.action_mailer.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS', 'mail.garyandstephanie.com'),
    port: ENV.fetch('SMTP_PORT', 25),
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: ENV.fetch('SMTP_AUTHENTICATION', 'plain')
  }
end

config.action_mailer.default_url_options = {
  host: ENV.fetch('MAILER_HOST', 'garyandstephanie.com')
}
```

**Replace with:**
```ruby
config.action_mailer.smtp_settings = {
  address: Rails.application.credentials.smtp[:address],
  port: Rails.application.credentials.smtp[:port],
  user_name: Rails.application.credentials.smtp[:username],
  password: Rails.application.credentials.smtp[:password],
  authentication: Rails.application.credentials.smtp[:authentication]
}

config.action_mailer.default_url_options = {
  host: Rails.application.credentials.mailer[:host]
}
```

### Step 3: Remove secrets.yml (Optional)

```bash
# Remove the old file
git rm config/secrets.yml

# Or update it to use credentials
# Edit config/secrets.yml:
```

```yaml
production:
  secret_key_base: <%= Rails.application.credentials.secret_key_base %>
```

### Step 4: Update .gitignore

Ensure these lines are in `.gitignore`:

```
# Ignore master key for decrypting credentials
/config/master.key

# Ignore local environment files
.env
.env.local
```

### Step 5: Update GitHub Actions

Edit `.github/workflows/ci-cd.yml`:

**Change:**
```yaml
- name: Setup secrets and database
  run: |
    cp config/database.yml.example config/database.yml || true
    bundle exec rails db:create db:schema:load
  env:
    SECRET_KEY_BASE: ${{ secrets.SECRET_KEY_BASE }}
```

**To:**
```yaml
- name: Setup credentials and database
  run: |
    cp config/database.yml.example config/database.yml || true
    # Create master.key from GitHub Secret
    echo "${{ secrets.RAILS_MASTER_KEY }}" > config/master.key
    bundle exec rails db:create db:schema:load
```

### Step 6: Update GitHub Secrets

**Remove:**
- `SECRET_KEY_BASE`

**Add:**
```
Name: RAILS_MASTER_KEY
Value: <content of config/master.key>
```

To get the master.key content:
```bash
cat config/master.key
```

### Step 7: Deploy Platform Configuration

**Fly.io:**
```bash
# Get your master key
cat config/master.key

# Set it as a secret
fly secrets set RAILS_MASTER_KEY=<your-master-key>
```

**Railway:**
Add in dashboard Variables:
```
RAILS_MASTER_KEY=<your-master-key>
```

**Render:**
Add in Environment:
```
RAILS_MASTER_KEY=<your-master-key>
```

### Step 8: Test Locally

```bash
# Test that credentials work
rails console

# Should print your secret
Rails.application.credentials.secret_key_base

# Should print your SMTP config
Rails.application.credentials.smtp
```

### Step 9: Commit and Push

```bash
git add config/credentials.yml.enc config/.gitignore
git rm config/secrets.yml  # if removing
git commit -m "Migrate to encrypted credentials"
git push
```

---

## Verification Checklist

- [ ] `config/master.key` exists locally (not in git)
- [ ] `config/credentials.yml.enc` exists and is committed
- [ ] `config/master.key` is in `.gitignore`
- [ ] GitHub Secret `RAILS_MASTER_KEY` is set
- [ ] Deployment platform has `RAILS_MASTER_KEY` environment variable
- [ ] Local `rails console` can access credentials
- [ ] Tests pass in CI/CD
- [ ] Production deployment works

---

## Rollback Plan

If something goes wrong:

1. **Keep secrets.yml:**
   ```bash
   git checkout config/secrets.yml
   ```

2. **Revert GitHub Actions:**
   ```bash
   git revert <commit-hash>
   ```

3. **Remove credentials:**
   ```bash
   rm config/credentials.yml.enc
   rm config/master.key
   ```

---

## Benefits of Migration

✅ **Security:** Production secrets no longer in repository
✅ **Best Practice:** Using modern Rails approach
✅ **Centralized:** All secrets in one encrypted file
✅ **Team-friendly:** Each developer can have their own master.key

## Reasons to Keep secrets.yml

✅ **Simplicity:** Current system works fine
✅ **Low Risk:** Wedding website doesn't handle sensitive data
✅ **Less Complexity:** No encryption to manage
✅ **Already Working:** Why fix what isn't broken?

---

## Recommendation

**For this wedding website:**
- Current `secrets.yml` approach is **fine**
- Consider migration if:
  - You handle payment information
  - You store sensitive user data
  - Multiple developers need different credentials
  - You want to follow best practices

**Not urgent** - The app works great as-is!
