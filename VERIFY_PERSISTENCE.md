# Verifying Persistent Storage on Fly.io

This guide shows how to verify your data is truly persistent.

## Current Setup

Your app uses:
- **SQLite database** at `/data/production.sqlite3`
- **Persistent volume** named `sqlite_data` (1GB)
- **Free tier** - costs $0/month

---

## Test 1: Check Volume Exists

```bash
# List all volumes
fly volumes list

# Expected output:
# ID              NAME            SIZE    REGION  ATTACHED TO
# vol_xxx         sqlite_data     1GB     iad     app-name
```

✅ If you see your volume, it's persistent!

---

## Test 2: Check Database Location

```bash
# SSH into your app
fly ssh console

# Check database file exists
ls -lh /data/production.sqlite3

# Expected output:
# -rw-r--r-- 1 rails rails 123M Jan 19 12:00 /data/production.sqlite3
```

✅ If file exists in `/data/`, it's on the persistent volume!

---

## Test 3: Create Test Data & Verify Persistence

### Step 1: Create test data
```bash
# Open Rails console
fly ssh console -C "bundle exec rails console"

# Create a test user (in Rails console)
User.create!(email: "test@example.com", password: "password123")

# Verify it was created
User.count
# Should show the count

# Exit console
exit
```

### Step 2: Restart the app
```bash
# Restart to clear any in-memory data
fly apps restart gary-stephanie-wedding

# Wait 30 seconds for restart
sleep 30
```

### Step 3: Verify data persisted
```bash
# Open Rails console again
fly ssh console -C "bundle exec rails console"

# Check if user still exists
User.find_by(email: "test@example.com")
# Should return the user object

User.count
# Should show same count as before

# Clean up test data
User.find_by(email: "test@example.com")&.destroy
```

✅ **If the data survived the restart, your storage is persistent!**

---

## Test 4: Check Volume Storage Usage

```bash
# Check how much space is used
fly ssh console -C "df -h /data"

# Expected output:
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/vdc        974M  123M  835M  13% /data
```

This shows:
- Total size: 1GB (974M)
- Used: Your database size
- Available: Remaining space

---

## What Makes It Persistent?

### In fly.toml:
```toml
[[mounts]]
  source = "sqlite_data"      # The persistent volume
  destination = "/data"        # Where it's mounted
```

### In config/database.yml:
```yaml
production:
  database: /data/production.sqlite3  # Stored on persistent volume
```

### The Volume:
- Created with: `fly volumes create sqlite_data --size 1`
- Survives: App restarts, redeployments, VM changes
- Deleted only: When you manually run `fly volumes delete`

---

## Common Misconceptions

### ❌ "The file system is ephemeral"
**TRUE** for most of the file system (`/rails/`, `/tmp/`, etc.)
**FALSE** for `/data/` (mounted from persistent volume)

### ❌ "SQLite isn't suitable for production"
**TRUE** for high-traffic multi-server apps
**FALSE** for single-server apps like yours (perfect fit!)

### ❌ "I need PostgreSQL for persistence"
**FALSE** - SQLite on persistent volume is just as persistent!

---

## Scaling Considerations

### Your Current Setup Works Great For:
- ✅ Single region deployment
- ✅ Low to medium traffic (<1000 concurrent users)
- ✅ Wedding websites, personal sites, small apps
- ✅ Budget-conscious projects

### When to Migrate to PostgreSQL:
- 🔄 Need multi-region writes (distributed database)
- 🔄 Heavy concurrent write traffic (>100 writes/sec)
- 🔄 Multiple app instances writing simultaneously
- 🔄 Need advanced database features (replication, etc.)

**For your wedding website:** SQLite is perfect! ✅

---

## Cost Breakdown

### Current Setup (FREE):
```
Fly.io Free Tier:
- 3 shared-cpu VMs (256MB each)  ✅ Using 1
- 3GB persistent volumes          ✅ Using 1GB
- 160GB outbound transfer         ✅ Using <1GB

Your usage:
- 1 VM (256MB)     = $0
- 1GB volume       = $0
- <10GB transfer   = $0
----------------------------
Total:             = $0/month
```

### If You Exceeded Free Tier:
```
Paid pricing:
- Additional VM    = $1.94/month
- Additional 1GB   = $0.15/month
- Transfer         = $0.02/GB
```

**Your wedding website will stay free!** 🎉

---

## Alternative: Upgrade to LiteFS (Advanced)

If you want SQLite with multi-region support:

**LiteFS** (Distributed SQLite by Fly.io)
- Cost: Same as regular volumes
- Benefit: Read replicas in multiple regions
- Complexity: More setup required

Only needed if you want global low-latency reads.

---

## Backup Your Data (Recommended)

### Manual Backup:
```bash
# Download database to local machine
fly ssh sftp get /data/production.sqlite3

# This downloads to current directory
# Store in safe location (not in git!)
```

### Automated Backups:
```bash
# Create a backup script (run weekly)
fly ssh console -C "sqlite3 /data/production.sqlite3 '.backup /data/backup.sqlite3'"

# Download backup
fly ssh sftp get /data/backup.sqlite3
```

---

## Summary

✅ **Your current setup IS persistent**
✅ **Your current setup IS free**
✅ **Your current setup is perfect for a wedding website**

No changes needed! 🎉

---

## Need More Space?

If you ever need more than 1GB:

```bash
# Extend volume to 2GB
fly volumes extend <volume-id> --size 2

# Still within free tier (3GB limit)
```

Or create larger volume:
```bash
fly volumes create sqlite_data_large --size 3 --region iad
# Update fly.toml to use new volume
```

---

## Conclusion

**Your data is safe and persistent!**

The Fly.io persistent volume ensures:
- Data survives restarts
- Data survives deployments
- Data survives VM migrations
- Data only deleted if you manually delete the volume

**No migration needed. You're all set!** ✅
