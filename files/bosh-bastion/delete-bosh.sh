#!/bin/bash -eu

source ./bosh.properties

# Define properties
GCP_PROJECT=${project_id}
GCP_REGION=${region}
GCP_ZONE=${zone}
GCP_NETWORK=${network}
GCP_SUBNETWORK=${subnetwork}
SERVICE_ACCOUNT=${GCP_ENV}-automated-${GCP_PROJECT}
# End of properties

bosh delete-env bosh-deployment/bosh.yml \
    --state=director-state.json \
    --vars-store=director-creds.yml \
    -o bosh-deployment/gcp/cpi.yml \
    -v director_name=${GCP_PROJECT} \
    -v internal_cidr=10.0.0.0/26 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    --var-file gcp_credentials_json=${SERVICE_ACCOUNT}.key.json \
    -v project_id=${GCP_PROJECT} \
    -v zone=${GCP_ZONE} \
    -v tags=[internal,no-ip] \
    -v network=${GCP_NETWORK} \
    -v subnetwork=${GCP_SUBNETWORK}
