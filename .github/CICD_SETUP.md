# CI/CD Pipeline Setup Guide

This document explains how to set up and use the CI/CD pipeline for this project.

## 🚀 Quick Start

The CI/CD pipeline automatically:
- ✅ Runs tests on every PR
- ✅ Runs linting and security checks
- ✅ Deploys to production when merged to main
- ✅ Generates code coverage reports

## 📋 What Runs When

### On Pull Request Creation/Update
1. **Test Suite** - Runs all RSpec tests
2. **Code Coverage** - Checks that coverage meets minimum threshold
3. **RuboCop Lint** - Checks code style
4. **Brakeman Security Scan** - Checks for security vulnerabilities
5. **Dependency Audit** - Checks for vulnerable gem versions
6. **Quick Checks** - Validates Gemfile.lock, checks for debug statements
7. **Auto-labeling** - Adds size labels (xs/s/m/l/xl) to PRs

### On Merge to Main/Master
1. **All PR checks** (tests, linting, security)
2. **Automatic Deployment** to your chosen platform (Fly.io/Railway/Render)

## 🔧 Setup Instructions

### 1. Choose Your Deployment Platform

Uncomment the appropriate deployment job in `.github/workflows/ci-cd.yml`:

#### For Fly.io (Recommended):
```yaml
deploy-fly:
  name: Deploy to Fly.io
  # ... (already uncommented by default)
```

#### For Railway:
Comment out `deploy-fly` and uncomment `deploy-railway`

#### For Render:
Comment out `deploy-fly` and uncomment `deploy-render`

### 2. Set Up GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions → New repository secret

#### For Fly.io:
```bash
# Get your Fly.io API token
fly auth token

# Add to GitHub Secrets:
Name: FLY_API_TOKEN
Value: <your-token>
```

#### For Railway:
```bash
# Get your Railway token from railway.app/account/tokens

# Add to GitHub Secrets:
Name: RAILWAY_TOKEN
Value: <your-token>
```

#### For Render:
```bash
# Get your API key from render.com dashboard
# Get your service ID from the service URL

# Add to GitHub Secrets:
Name: RENDER_API_KEY
Value: <your-api-key>

Name: RENDER_SERVICE_ID
Value: <your-service-id>
```

#### Additional Secrets (All Platforms):
```
Name: RAILS_MASTER_KEY
Value: <paste the content of your config/master.key file>
```

**To get your master key:**
```bash
cat config/master.key
```

⚠️ **IMPORTANT:** Never commit or share your master.key file publicly!

**Note:** This app now uses Rails encrypted credentials (modern approach). All secrets including SMTP configuration are stored in the encrypted `config/credentials.yml.enc` file and decrypted using the master key. See [SECRETS_SETUP.md](./SECRETS_SETUP.md) for detailed configuration.

### 3. Test Your CI/CD Pipeline

#### Create a test PR:
```bash
# Create a new branch
git checkout -b test-ci-cd

# Make a small change
echo "# Testing CI/CD" >> README.md

# Commit and push
git add README.md
git commit -m "Test CI/CD pipeline"
git push origin test-ci-cd

# Open a PR on GitHub
```

Watch the "Actions" tab to see your pipeline run!

## 📊 Monitoring Your Pipeline

### View Build Status
- Go to your repository on GitHub
- Click the "Actions" tab
- You'll see all workflow runs

### Check Coverage Reports
1. Click on any workflow run
2. Scroll to "Artifacts"
3. Download "coverage-report"
4. Open `coverage/index.html` in a browser

### Add Status Badge to README

Add this to your README.md:
```markdown
![CI/CD Status](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/CI%2FCD%20Pipeline/badge.svg)
```

Replace `YOUR_USERNAME` and `YOUR_REPO` with your actual values.

## 🔍 What Each Job Does

### Test Job
- Sets up Ruby 3.3.6
- Installs dependencies (cached for speed)
- Sets up SQLite database
- Runs RSpec tests
- Generates coverage report
- Uploads test results and coverage as artifacts

### Lint Job
- Runs RuboCop for code style
- Runs Brakeman for security issues
- Checks for vulnerable dependencies with bundler-audit

### Deploy Job
- Only runs on merge to main/master
- Only runs if tests and linting pass
- Deploys to your chosen platform

## 🐛 Troubleshooting

### Tests failing in CI but passing locally?
```bash
# Run tests exactly as CI does:
RAILS_ENV=test bundle exec rspec
```

### Database issues?
```bash
# Ensure database.yml.example exists:
cp config/database.yml config/database.yml.example
git add config/database.yml.example
git commit -m "Add database.yml.example for CI"
```

### Deployment failing?
1. Check that secrets are set correctly in GitHub
2. Verify your platform is configured:
   - Fly.io: Run `fly status` locally
   - Railway: Check railway.app dashboard
   - Render: Check render.com dashboard

### RuboCop too strict?
Edit `.rubocop.yml` to adjust rules, or disable specific checks:
```yaml
# .rubocop.yml
AllCops:
  NewCops: enable
  Exclude:
    - 'db/**/*'
    - 'config/**/*'
    - 'bin/**/*'
```

## 📈 Performance Tips

### Speed up CI runs:
1. **Cache gems** (already configured via `bundler-cache: true`)
2. **Parallelize tests** (add to your RSpec command):
   ```yaml
   run: bundle exec rspec --format progress --format ParallelTests::RSpec::RuntimeLogger --out tmp/spec_runtime.log
   ```
3. **Split test files** across multiple runners (advanced)

### Reduce GitHub Actions minutes usage:
1. **Run only on changed files** (add path filters)
2. **Skip CI for doc changes** (add `[skip ci]` to commit messages)
3. **Use self-hosted runners** (for very active repos)

## 🔐 Security Best Practices

1. ✅ **Never commit secrets** - Always use GitHub Secrets
2. ✅ **Rotate tokens regularly** - Update API tokens every 90 days
3. ✅ **Use least privilege** - Give tokens minimum required permissions
4. ✅ **Review Brakeman warnings** - Address security issues promptly
5. ✅ **Keep dependencies updated** - Run `bundle update` monthly

## 📚 Additional Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Fly.io Deploy Docs](https://fly.io/docs/rails/getting-started/)
- [Railway Deploy Docs](https://docs.railway.app/deploy/deployments)
- [Render Deploy Docs](https://render.com/docs/deploy-rails)

## 🆘 Getting Help

If you encounter issues:
1. Check the "Actions" tab for detailed error logs
2. Review this guide's troubleshooting section
3. Check your deployment platform's status page
4. Open an issue in the repository

## ✨ Advanced Features

### Add Slack Notifications
```yaml
- name: Slack Notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Deployment to production completed!'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
  if: always()
```

### Add automatic PR comments with coverage
```yaml
- name: Comment PR with coverage
  uses: romeovs/lcov-reporter-action@v0.3.1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    lcov-file: ./coverage/lcov.info
```

### Add performance testing
```yaml
- name: Run performance tests
  run: bundle exec rspec --tag performance
```

---

**Happy Deploying! 🚀**
