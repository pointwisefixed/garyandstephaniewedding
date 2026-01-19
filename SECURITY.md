# 🔐 SECURITY NOTICE

## Old Secrets in Git History

⚠️ **IMPORTANT:** This repository previously stored secrets in plain text in `config/secrets.yml`.

While we've migrated to encrypted credentials, the **old secrets are still visible in git history**.

### What Was Exposed

The following secrets are visible in old commits:
- Production `secret_key_base`
- SMTP password (`ILSM2015!`)

### What You Should Do

#### 1. Rotate All Secrets

**Change your SMTP password immediately:**
- The password `ILSM2015!` is visible in git history
- Update it with your email provider
- Update the encrypted credentials:
  ```bash
  EDITOR=nano rails credentials:edit
  # Update smtp.password value
  ```

**Generate new secret_key_base:**
```bash
# Generate new secret
rails secret

# Add to credentials
EDITOR=nano rails credentials:edit
# Update secret_key_base value
```

#### 2. Verify Master Key is Secret

The master key should NEVER be committed:
```bash
# Check it's ignored
git check-ignore config/master.key
# Should output: config/master.key

# Verify it's not in repo
git ls-files | grep master.key
# Should output nothing
```

#### 3. Update Deployment Secrets

After rotating secrets:

**GitHub Actions:**
```
Update: RAILS_MASTER_KEY
```

**Deployment Platform (Fly.io/Railway/Render):**
```bash
# Fly.io
fly secrets set RAILS_MASTER_KEY=$(cat config/master.key)

# Railway/Render: Update via dashboard
```

### Current Security Posture

✅ **Good:**
- New secrets stored in encrypted credentials
- Master key never committed (in .gitignore)
- SMTP credentials encrypted

⚠️ **Action Required:**
- Rotate SMTP password (currently exposed in git history)
- Optional: Generate new secret_key_base
- Optional: Rewrite git history (advanced, risky)

### Why We Can't Just Delete Old Commits

Git history is permanent once pushed. Options:

**Option 1: Rotate Secrets (Recommended)**
- Change all exposed passwords
- Old secrets become useless
- Simple and safe

**Option 2: Rewrite Git History (Advanced, Risky)**
- Use `git filter-branch` or `BFG Repo Cleaner`
- Force push to rewrite history
- All collaborators must re-clone
- Can break existing clones/forks
- **Not recommended for this project**

### Going Forward

All new secrets use encrypted credentials:
- `config/credentials.yml.enc` - Safe to commit
- `config/master.key` - NEVER commit (in .gitignore)
- All team members need the master key
- Store master key in password manager

### Questions?

See:
- `.github/SECRETS_SETUP.md` - How to manage encrypted credentials
- `.github/CICD_SETUP.md` - How to set up CI/CD secrets

---

**Last Updated:** 2026-01-19
**Status:** Migrated to encrypted credentials, old secrets need rotation
