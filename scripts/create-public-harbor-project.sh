#!/bin/bash

# Script usage function
function usage() {
  echo "Usage: $0 <HARBOR_HOSTNAME> <HARBOR_USERNAME> <HARBOR_PASSWORD> <HARBOR_PROJECT_NAME>"
  echo "For example: $0 l01-tkgm-harbor.cloudnativeapps.cloud admin 'VMware1!' my-public-project"
  exit 1
}

# Input validation
if [ $# -ne 4 ]
then
  usage
fi

HARBOR_HOSTNAME=$1
HARBOR_USERNAME=$2
HARBOR_PASSWORD=$3
HARBOR_PROJECT_NAME=$4

# Create Harbor project
echo "Creating Harbor project '$HARBOR_PROJECT_NAME' on Harbor '$HARBOR_HOSTNAME'"

curl -k -X POST -H "Content-Type: application/json" \
-u "$HARBOR_USERNAME:$HARBOR_PASSWORD" \
"https://$HARBOR_HOSTNAME/api/v2.0/projects" \
-d '
{
    "project_name": '\"$HARBOR_PROJECT_NAME\"',
    "public": true
}'

echo "Done"