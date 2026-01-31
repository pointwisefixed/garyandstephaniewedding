# Migrating from SQLite to PostgreSQL

If you decide you need PostgreSQL instead of SQLite, here's how to migrate.

## When to Migrate

**Reasons to migrate:**
- 🔄 Need multi-region deployment with writes
- 🔄 Heavy concurrent write traffic
- 🔄 Multiple app instances
- 🔄 Advanced database features (full-text search, JSON queries, etc.)

**Reasons to stay with SQLite:**
- ✅ Single region is fine
- ✅ Low to medium traffic
- ✅ Simple setup preferred
- ✅ Free tier is important

---

## Option 1: Supabase (Best Free Tier)

### Pros:
- FREE forever tier (500MB database)
- Includes authentication, storage, real-time features
- Global CDN
- Excellent dashboard

### Setup:

#### 1. Create Supabase Account
```bash
# Go to https://supabase.com
# Sign up and create new project
# Copy your database connection string
```

#### 2. Update Gemfile
```ruby
# Replace
gem 'sqlite3', '~> 2.4'

# With
gem 'pg', '~> 1.5'
```

#### 3. Update database.yml
```yaml
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV['DATABASE_URL'] %>
```

#### 4. Set Database URL
```bash
# Add to encrypted credentials
EDITOR=nano rails credentials:edit

# Add:
database_url: postgresql://postgres:[password]@db.xxx.supabase.co:5432/postgres

# Or set on Fly.io
fly secrets set DATABASE_URL=postgresql://postgres:[password]@db.xxx.supabase.co:5432/postgres
```

#### 5. Migrate Data
```bash
# Export from SQLite
fly ssh console -C "bundle exec rails runner 'require \"yaml\"; puts User.all.to_yaml' > users.yml"

# In new app with PostgreSQL
bundle exec rails runner 'YAML.load_file("users.yml").each { |user| User.create!(user.attributes) }'
```

---

## Option 2: Neon (Serverless PostgreSQL)

### Pros:
- FREE tier (3GB storage)
- Serverless (auto-sleeps, saves money)
- Instant branching (great for testing)
- Modern, fast

### Setup:

#### 1. Create Neon Account
```bash
# Go to https://neon.tech
# Sign up and create project
# Copy connection string
```

#### 2. Same Gemfile/database.yml changes as Supabase

#### 3. Set Database URL
```bash
fly secrets set DATABASE_URL=postgresql://user:password@ep-xxx.us-east-2.aws.neon.tech/neondb
```

---

## Option 3: Fly.io PostgreSQL

### Pros:
- Same platform as your app
- Fast local connection
- Full control

### Cons:
- Uses your VM allocation (not truly free)
- More complex setup

### Setup:

```bash
# Create Postgres cluster
fly postgres create

# Follow prompts, then attach to your app
fly postgres attach --app gary-stephanie-wedding <postgres-app-name>

# This automatically sets DATABASE_URL
```

---

## Migration Steps (Generic)

### 1. Backup Current Data
```bash
# Download SQLite database
fly ssh sftp get /data/production.sqlite3

# Keep this safe!
```

### 2. Update Dependencies
```ruby
# Gemfile
group :development, :test do
  gem 'sqlite3', '~> 2.4'
end

group :production do
  gem 'pg', '~> 1.5'
end
```

### 3. Update Database Config
```yaml
# config/database.yml
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV['DATABASE_URL'] %>

development:
  adapter: sqlite3
  database: db/development.sqlite3

test:
  adapter: sqlite3
  database: db/test.sqlite3
```

### 4. Create Migration Script
```ruby
# lib/tasks/migrate_to_postgres.rake
namespace :db do
  desc "Migrate data from SQLite to PostgreSQL"
  task migrate_to_postgres: :environment do
    # This assumes both databases are configured
    # Run this ONCE to copy data

    ActiveRecord::Base.transaction do
      # Migrate tables in order (respecting foreign keys)

      # Users
      old_db = SQLite3::Database.new('db/production_backup.sqlite3')
      old_db.execute("SELECT * FROM users") do |row|
        User.create!(
          email: row['email'],
          encrypted_password: row['encrypted_password'],
          # ... all fields
        )
      end

      # Entrees
      old_db.execute("SELECT * FROM entrees") do |row|
        Entree.create!(
          name: row['name'],
          description: row['description']
        )
      end

      # Continue for all tables...
    end
  end
end
```

### 5. Deploy
```bash
# Install dependencies
bundle install

# Update Fly.io secret
fly secrets set DATABASE_URL=<your-postgres-url>

# Deploy
fly deploy

# Run migrations
fly ssh console -C "bundle exec rails db:migrate"
```

### 6. Migrate Data
```bash
# Copy SQLite backup to local
# Run migration script locally or on Fly
fly ssh console -C "bundle exec rails db:migrate_to_postgres"
```

---

## Cost Comparison

### Current (SQLite on Fly.io):
```
Cost: $0/month (free tier)
```

### Supabase:
```
Free tier:  $0/month (500MB, forever)
Pro tier:   $25/month (8GB, better features)
```

### Neon:
```
Free tier:  $0/month (3GB, with limits)
Scale tier: $19/month (starts at, usage-based)
```

### Fly.io Postgres:
```
Development: ~$2/month (shared-cpu-1x, 256MB)
Production:  ~$15/month (dedicated-cpu-1x, 2GB)
```

### Render:
```
Free tier:  $0/month (expires after 90 days)
Starter:    $7/month (256MB)
```

---

## Recommendation

**For your wedding website:**

1. **Keep SQLite** if:
   - ✅ Current setup is working
   - ✅ Single region is fine
   - ✅ Want to stay free
   - ✅ Don't need advanced features

2. **Migrate to Supabase** if:
   - You want PostgreSQL features
   - You want authentication/storage built-in
   - You want a generous free tier
   - You're okay with external dependency

3. **Migrate to Neon** if:
   - You want serverless benefits
   - You need instant dev branches
   - You're okay with some limits on free tier

4. **Use Fly.io Postgres** if:
   - You want everything on one platform
   - You're willing to pay ~$2/month
   - You need full control

---

## Easy Migration Path (Recommended)

If you want to try PostgreSQL without losing SQLite:

### Use Both Temporarily:
```ruby
# Gemfile
gem 'sqlite3', '~> 2.4'
gem 'pg', '~> 1.5'

# config/database.yml
production:
  adapter: <%= ENV.fetch('DATABASE_ADAPTER', 'sqlite3') %>
  database: <%= ENV.fetch('DATABASE_URL', '/data/production.sqlite3') %>
```

Then switch between them:
```bash
# Use SQLite (default)
fly deploy

# Try PostgreSQL
fly secrets set DATABASE_ADAPTER=postgresql
fly secrets set DATABASE_URL=postgresql://...
fly deploy
```

---

## Summary

**Current setup (SQLite on Fly.io):**
- ✅ Persistent
- ✅ Free
- ✅ Simple
- ✅ Perfect for wedding websites

**Only migrate if you truly need:**
- PostgreSQL-specific features
- Multi-region writes
- Heavy concurrent traffic
- Multiple app instances

**Your wedding website is fine with SQLite!** 🎉

---

## Need Help Deciding?

Ask yourself:
1. Is SQLite causing problems? → **Probably not**
2. Do I need PostgreSQL features? → **Probably not**
3. Will I exceed 1GB database? → **Probably not**
4. Do I have heavy concurrent writes? → **Probably not**

**If you answered "Probably not" to all → KEEP SQLITE!**
