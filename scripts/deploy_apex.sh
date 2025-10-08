#!/bin/bash
#
# deploy_apex.sh - Script to deploy Oracle APEX applications from APX files
#
# Usage: ./deploy_apex.sh [APX_FILE] [ENVIRONMENT]
#
# This script deploys Oracle APEX application export files to a specified environment.
# It requires SQLcl to be installed and database connection parameters to be configured.
#

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
APX_DIR="${PROJECT_ROOT}/apex-apps"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [APX_FILE] [ENVIRONMENT]

Arguments:
  APX_FILE      Path to the APX file to deploy (relative to apex-apps directory or absolute path)
  ENVIRONMENT   Target environment (dev, test, prod)

Environment Variables:
  DB_HOST       Database hostname (required)
  DB_PORT       Database port (default: 1521)
  DB_SERVICE    Database service name (required)
  DB_USER       Database username (required)
  DB_PASSWORD   Database password (required)
  WORKSPACE     APEX workspace name (default: TRAINING_PLAN)

Examples:
  $0 training_plan_app.apx dev
  $0 /path/to/app.apx prod

EOF
}

# Parse arguments
APX_FILE="${1}"
ENVIRONMENT="${2:-dev}"

if [ -z "$APX_FILE" ]; then
    log_error "APX file not specified"
    show_usage
    exit 1
fi

# Resolve APX file path
if [ ! -f "$APX_FILE" ]; then
    # Try relative to apex-apps directory
    if [ -f "${APX_DIR}/${APX_FILE}" ]; then
        APX_FILE="${APX_DIR}/${APX_FILE}"
    else
        log_error "APX file not found: $APX_FILE"
        exit 1
    fi
fi

log_info "Deploying APX file: $APX_FILE"
log_info "Target environment: $ENVIRONMENT"

# Check required environment variables
if [ -z "$DB_HOST" ] || [ -z "$DB_SERVICE" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    log_error "Missing required database connection parameters"
    log_info "Please set DB_HOST, DB_SERVICE, DB_USER, and DB_PASSWORD environment variables"
    exit 1
fi

DB_PORT="${DB_PORT:-1521}"
WORKSPACE="${WORKSPACE:-TRAINING_PLAN}"

# Check if SQLcl is installed
if ! command -v sql &> /dev/null; then
    log_error "SQLcl is not installed or not in PATH"
    log_info "Please install Oracle SQLcl from: https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/"
    exit 1
fi

# Create connection string
CONNECT_STRING="${DB_USER}/${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_SERVICE}"

log_info "Connecting to database..."

# Deploy the APX file using SQLcl
sql -s "${CONNECT_STRING}" << EOF
-- Set APEX workspace context
BEGIN
    apex_application_install.set_workspace('${WORKSPACE}');
    apex_application_install.generate_offset;
    apex_application_install.set_schema('${DB_USER}');
    apex_application_install.set_application_alias('TRAINING_PLAN');
END;
/

-- Import the APX file
@${APX_FILE}

-- Show deployment summary
SELECT 
    application_id,
    application_name,
    owner,
    version,
    last_updated_on
FROM apex_applications
WHERE workspace = '${WORKSPACE}'
ORDER BY last_updated_on DESC
FETCH FIRST 5 ROWS ONLY;

EXIT;
EOF

if [ $? -eq 0 ]; then
    log_info "✓ APX file deployed successfully to ${ENVIRONMENT} environment"
else
    log_error "✗ Deployment failed"
    exit 1
fi

log_info "Deployment completed at $(date)"
