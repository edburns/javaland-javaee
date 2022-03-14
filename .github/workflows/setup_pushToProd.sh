#!/usr/bin/env bash
################################################
# This script is invoked by a human who:
# - can create repository secrets in the github repo from which this file was cloned.
# - has the gh client >= 2.0.0 installed.
#
# This script initializes the repo from which this file is was cloned
# with the necessary secrets to run the workflows.
#
# Script design taken from https://github.com/microsoft/NubesGen.
#
################################################

################################################
# Set environment variables - the main variables you might want to configure.
#
OWNER_REPONAME=
# End set environment variables
################################################


set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

setup_colors

read -r -p "Enter OlAksClusterName: " EJB01OlAksClusterName
read -r -p "Enter OlAksResourceGroup: " EJB01OlAksResourceGroup
read -r -p "Enter azureACRServer: " EJB01azureACRServer
read -r -p "Enter azureACRUserName: " EJB01azureACRUserName
read -r -p "Enter dbName: " EJB01dbName

# get OWNER_REPONAME if not set at the beginning of this file
if [ "$OWNER_REPONAME" == '' ] ; then
    read -r -p "Enter owner/reponame (blank for upsteam of current fork): " OWNER_REPONAME
fi

if [ -z "${OWNER_REPONAME}" ] ; then
    GH_FLAGS=""
else
    GH_FLAGS="--repo ${OWNER_REPONAME}"
fi

# Check GitHub CLI status
msg "${GREEN}(2/6) Checking GitHub CLI status...${NOFORMAT}"
USE_GITHUB_CLI=false
{
  gh auth status && USE_GITHUB_CLI=true && msg "${YELLOW}GitHub CLI is installed and configured!"
} || {
  msg "${YELLOW}Cannot use the GitHub CLI. ${GREEN}No worries! ${YELLOW}We'll set up the GitHub secrets manually."
  USE_GITHUB_CLI=false
}

exit

msg "${GREEN}(6/6) Create secrets in GitHub"
if $USE_GITHUB_CLI; then
  {
    msg "${GREEN}Using the GitHub CLI to set secrets.${NOFORMAT}"
    gh ${GH_FLAGS} secret set EJB01OlAksClusterName -b"${EJB01OlAksClusterName}"
    gh ${GH_FLAGS} secret set EJB01OlAksResourceGroup -b"${EJB01OlAksResourceGroup}"
    gh ${GH_FLAGS} secret set EJB01azureACRServer -b"${EJB01azureACRServer}"
    gh ${GH_FLAGS} secret set EJB01azureACRUserName -b"${EJB01azureACRUserName}"
    gh ${GH_FLAGS} secret set EJB01dbName -b"${EJB01dbName}"
  } || {
    USE_GITHUB_CLI=false
  }
fi
if [ $USE_GITHUB_CLI == false ]; then
  msg "${NOFORMAT}======================MANUAL SETUP======================================"
  msg "${GREEN}Using your Web browser to set up secrets..."
  msg "${NOFORMAT}Go to the GitHub repository you want to configure."
  msg "${NOFORMAT}In the \"settings\", go to the \"secrets\" tab and the following secrets:"
  msg "(in ${YELLOW}yellow the secret name and${NOFORMAT} in ${GREEN}green the secret value)"
  msg "${YELLOW}\"EJB01OlAksClusterName\""
  msg "${GREEN}${EJB01OlAksClusterName}"
  msg "${YELLOW}\"EJB01OlAksResourceGroup\""
  msg "${GREEN}${EJB01OlAksResourceGroup}"
  msg "${YELLOW}\"EJB01azureACRServer\""
  msg "${GREEN}${EJB01azureACRServer}"
  msg "${YELLOW}\"EJB01azureACRUserName\""
  msg "${GREEN}${EJB01azureACRUserName}"
  msg "${YELLOW}\"EJB01dbName\""
  msg "${GREEN}${EJB01dbName}"
  msg "${NOFORMAT}========================================================================"
fi
msg "${GREEN}Secrets configured"
