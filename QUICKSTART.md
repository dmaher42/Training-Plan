# Quick Start Guide

This guide will help you get started with deploying Oracle APEX applications using this repository.

## For Developers

### First Time Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/dmaher42/Training-Plan.git
   cd Training-Plan
   ```

2. **Install Oracle SQLcl** (if not already installed)
   - Download from: https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/
   - Extract and add to your PATH

3. **Configure your local environment**
   ```bash
   cp config.env.example config.local.env
   # Edit config.local.env with your database details
   ```

### Deploying an APX File

```bash
# Source your configuration
source config.local.env

# Deploy to development
./scripts/deploy_apex.sh training_plan_app.apx dev
```

## For DevOps/CI-CD

### Setting Up GitHub Actions

1. **Add GitHub Secrets**
   
   Go to repository Settings → Secrets and variables → Actions
   
   Add these secrets for each environment:
   - `DEV_DB_HOST`, `DEV_DB_PORT`, `DEV_DB_SERVICE`
   - `DEV_DB_USER`, `DEV_DB_PASSWORD`, `DEV_WORKSPACE`
   - Similar secrets for `PROD_*`

2. **Enable GitHub Actions**
   
   The workflow will automatically run when:
   - APX files are pushed to `develop` branch (deploys to dev)
   - APX files are pushed to `main` branch (deploys to prod)
   - Manual workflow dispatch is triggered

### Manual Deployment from GitHub

1. Go to the Actions tab
2. Select "Deploy APEX Application"
3. Click "Run workflow"
4. Choose:
   - Environment (dev/test/prod)
   - APX file name
5. Click "Run workflow"

## Common Tasks

### Export an APEX Application

**From APEX UI:**
1. App Builder → Your App → Export/Import
2. Click Export
3. Download the APX file
4. Save to `apex-apps/` directory

**From SQLcl:**
```bash
sql username/password@database
apex export -applicationid 100
```

### Update an APX File in Repository

```bash
# Copy your new APX export to apex-apps directory
cp ~/Downloads/f100.sql apex-apps/training_plan_app.apx

# Commit and push
git add apex-apps/training_plan_app.apx
git commit -m "Update Training Plan application"
git push
```

### View Deployment History

```bash
# Check recent commits
git log --oneline apex-apps/

# See what changed in an APX file (can be large!)
git diff HEAD~1 apex-apps/training_plan_app.apx
```

## Troubleshooting

### "SQLcl not found"
- Install SQLcl and add to PATH
- Or specify full path in deployment script

### "Connection refused"
- Check database is running
- Verify hostname and port
- Check firewall rules
- Test with: `telnet $DB_HOST $DB_PORT`

### "Invalid credentials"
- Verify username and password
- Check user has APEX developer privileges
- Ensure workspace name is correct

### "Application already exists"
- APX import will update existing application
- To change behavior, edit the APX file's install options

## Best Practices

1. **Branch Strategy**
   - Feature branches for development
   - `develop` branch for testing
   - `main` branch for production

2. **Commit Messages**
   - Be descriptive about what changed
   - Example: "Add employee training module to APEX app"

3. **Testing**
   - Always test in dev environment first
   - Use pull requests for code review
   - Verify in test environment before production

4. **Backup**
   - Export and commit APX files regularly
   - Keep backups before major changes
   - Tag releases: `git tag -a v1.0 -m "Release 1.0"`

## Additional Resources

- [Oracle APEX Documentation](https://apex.oracle.com/en/learn/documentation/)
- [SQLcl Documentation](https://docs.oracle.com/en/database/oracle/sql-developer-command-line/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Getting Help

- Open an issue in this repository
- Check the main README.md for detailed information
- Contact the repository maintainer
