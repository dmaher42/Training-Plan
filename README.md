# Training-Plan

Oracle APEX Application Deployment Repository

## Overview

This repository contains Oracle APEX application export files (APX files) and deployment automation for the Training Plan application.

## Repository Structure

```
.
├── apex-apps/              # APEX application export files (.apx)
├── scripts/                # Deployment scripts
│   └── deploy_apex.sh     # Main deployment script
├── .github/workflows/      # GitHub Actions CI/CD workflows
│   └── deploy-apex.yml    # Automated deployment workflow
└── config.env.example      # Example configuration file
```

## Prerequisites

- Oracle Database with APEX installed
- Oracle SQLcl (for command-line deployment)
- Access credentials to target APEX workspace
- (Optional) GitHub repository secrets configured for CI/CD

## Quick Start

### 1. Configure Database Connection

Copy the example configuration file and customize it:

```bash
cp config.env.example config.local.env
```

Edit `config.local.env` with your database connection details:

```bash
DB_HOST=your-db-host
DB_PORT=1521
DB_SERVICE=your-service-name
DB_USER=your-apex-user
DB_PASSWORD=your-password
WORKSPACE=TRAINING_PLAN
```

**Important:** Never commit `config.local.env` to version control!

### 2. Manual Deployment

Deploy an APX file manually using the deployment script:

```bash
# Source your configuration
source config.local.env

# Deploy to development environment
./scripts/deploy_apex.sh training_plan_app.apx dev

# Deploy to production environment
./scripts/deploy_apex.sh training_plan_app.apx prod
```

### 3. Automated Deployment with GitHub Actions

The repository includes automated deployment workflows:

- **Push to `develop` branch**: Automatically deploys to development environment
- **Push to `main` branch**: Automatically deploys to production environment
- **Manual trigger**: Deploy any APX file to any environment via workflow dispatch

#### Configure GitHub Secrets

Add the following secrets to your GitHub repository:

**Development Environment:**
- `DEV_DB_HOST`
- `DEV_DB_PORT`
- `DEV_DB_SERVICE`
- `DEV_DB_USER`
- `DEV_DB_PASSWORD`
- `DEV_WORKSPACE`

**Production Environment:**
- `PROD_DB_HOST`
- `PROD_DB_PORT`
- `PROD_DB_SERVICE`
- `PROD_DB_USER`
- `PROD_DB_PASSWORD`
- `PROD_WORKSPACE`

#### Manual Workflow Trigger

1. Go to Actions tab in GitHub
2. Select "Deploy APEX Application" workflow
3. Click "Run workflow"
4. Choose environment and APX file
5. Click "Run workflow" button

## APX File Management

### Exporting Applications

Export your APEX application to an APX file:

**Using APEX UI:**
1. Navigate to App Builder
2. Select your application
3. Click Export/Import
4. Choose "Export"
5. Select appropriate options
6. Download the APX file

**Using SQLcl:**
```sql
apex export -applicationid 100 -workspaceid 12345
```

### Adding APX Files to Repository

1. Place your APX file in the `apex-apps/` directory
2. Commit and push:
```bash
git add apex-apps/your_app.apx
git commit -m "Add new APEX application export"
git push
```

## Deployment Script Usage

The `deploy_apex.sh` script supports the following options:

```bash
./scripts/deploy_apex.sh [APX_FILE] [ENVIRONMENT]

Arguments:
  APX_FILE      Path to APX file (relative to apex-apps/ or absolute)
  ENVIRONMENT   Target environment (dev, test, prod)

Environment Variables:
  DB_HOST       Database hostname (required)
  DB_PORT       Database port (default: 1521)
  DB_SERVICE    Database service name (required)
  DB_USER       Database username (required)
  DB_PASSWORD   Database password (required)
  WORKSPACE     APEX workspace name (default: TRAINING_PLAN)
```

## Troubleshooting

### SQLcl Not Found

Install Oracle SQLcl from:
https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/

Add SQLcl to your PATH or update the deployment script.

### Connection Issues

- Verify database hostname and port
- Check firewall rules
- Ensure database is accessible from deployment environment
- Verify APEX workspace exists

### Import Errors

- Check APX file syntax
- Verify workspace name matches target
- Ensure user has appropriate privileges
- Review database logs for detailed errors

## Best Practices

1. **Version Control**: Always commit APX files after application changes
2. **Testing**: Test deployments in development environment first
3. **Backup**: Keep backups of production APX files before deploying
4. **Documentation**: Update comments in APX files with change descriptions
5. **Security**: Never commit credentials or sensitive configuration
6. **Validation**: Use the automated validation in CI/CD pipeline

## Contributing

1. Create a feature branch
2. Export and commit your APEX application changes
3. Test deployment in development environment
4. Submit a pull request
5. Wait for automated validation
6. Merge after approval

## License

[Specify your license here]

## Support

For issues or questions, please open an issue in this repository.