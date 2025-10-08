# Deployment Checklist

Use this checklist when deploying APEX applications to ensure all steps are completed properly.

## Pre-Deployment

### Development Phase
- [ ] Application has been tested in development environment
- [ ] All database objects (tables, views, packages) are created
- [ ] Application exported from APEX (Export/Import → Export)
- [ ] APX file saved to `apex-apps/` directory with descriptive name
- [ ] APX file committed to version control
- [ ] Code review completed (if using pull requests)

### Configuration
- [ ] Database connection parameters verified
- [ ] Target workspace exists and is accessible
- [ ] Deployment user has necessary privileges
- [ ] SQLcl is installed and accessible (for manual deployment)
- [ ] GitHub secrets configured (for automated deployment)

## Deployment

### Manual Deployment
- [ ] Configuration file created/updated (`config.local.env`)
- [ ] Backup of existing application created (if updating)
- [ ] Deployment script executed: `./scripts/deploy_apex.sh [APX_FILE] [ENV]`
- [ ] Deployment completed without errors
- [ ] Deployment log reviewed for warnings

### Automated Deployment
- [ ] APX file pushed to appropriate branch
  - `develop` branch → Development environment
  - `main` branch → Production environment
- [ ] GitHub Actions workflow triggered
- [ ] Workflow completed successfully
- [ ] Deployment logs reviewed

## Post-Deployment

### Verification
- [ ] Application accessible at expected URL
- [ ] Login/authentication working
- [ ] Key functionality tested:
  - [ ] Homepage loads correctly
  - [ ] Navigation working
  - [ ] Forms submit successfully
  - [ ] Reports display data
  - [ ] Interactive components functional
- [ ] Database objects installed correctly
- [ ] Supporting objects (LOVs, lookups) populated

### Performance
- [ ] Page load times acceptable
- [ ] Queries executing efficiently
- [ ] No console errors in browser
- [ ] Server resource usage normal

### Documentation
- [ ] Deployment notes recorded
- [ ] Version number updated (if applicable)
- [ ] Release notes created/updated
- [ ] Stakeholders notified
- [ ] Git tag created for release: `git tag -a v1.0 -m "Release 1.0"`

## Rollback Plan (if needed)

- [ ] Backup APX file location identified
- [ ] Rollback procedure documented
- [ ] Stakeholders notified of rollback
- [ ] Previous version redeployed
- [ ] Verification completed
- [ ] Root cause analysis initiated

## Environment-Specific Considerations

### Development
- [ ] Test data available
- [ ] Development users can access
- [ ] Debug mode enabled if needed

### Test/Staging
- [ ] Test scenarios documented
- [ ] QA team notified
- [ ] Test data refreshed if needed
- [ ] Integration points tested

### Production
- [ ] Deployment window scheduled
- [ ] Maintenance page displayed (if applicable)
- [ ] Database backup completed
- [ ] Users notified of downtime (if applicable)
- [ ] Production access restricted during deployment
- [ ] Smoke tests completed
- [ ] Monitoring alerts configured
- [ ] Documentation updated
- [ ] Training provided (if needed)

## Troubleshooting

If deployment fails, check:
- [ ] Database connection parameters
- [ ] User privileges in target workspace
- [ ] Workspace name matches configuration
- [ ] APX file syntax/validity
- [ ] Database object dependencies
- [ ] Available database space
- [ ] Network connectivity
- [ ] Firewall rules

## Sign-off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Developer | | | |
| Reviewer | | | |
| Deployer | | | |
| QA | | | |
| Approver | | | |

## Notes

Record any issues, workarounds, or special considerations:

```
[Add notes here]
```
