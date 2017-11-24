#!/bin/bash -eu

terraform refresh > /dev/null 2>&1

GCP_ENV=$(terraform output workspace)

# Define properties
GCP_PROJECT=${project_id}
GCP_REGION=${region}
GCP_ZONE=${zone}
GCP_NETWORK=${network}
GCP_SUBNETWORK=${GCP_ENV}-control-${GCP_REGION}
SERVICE_ACCOUNT=automated-${GCP_PROJECT}
# End of properties

cd bosh-deployment
git pull
cd ..

echo "==================================================================="
bosh int bosh-deployment/bosh.yml \
    --vars-store=director-creds.yml \
    -o bosh-deployment/gcp/cpi.yml \
    -o bosh-deployment/uaa.yml \
    -o bosh-deployment/credhub.yml \
    -v director_name=${GCP_PROJECT} \
    -v internal_cidr=10.0.0.0/26 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    --var-file  gcp_credentials_json=${SERVICE_ACCOUNT}.key.json \
    -v project_id=${GCP_PROJECT} \
    -v zone=${GCP_ZONE} \
    -v tags=[internal,no-ip] \
    -v network=${GCP_NETWORK} \
    -v subnetwork=${GCP_SUBNETWORK}
echo "==================================================================="

bosh create-env bosh-deployment/bosh.yml \
    --state=director-state.json \
    --vars-store=director-creds.yml \
    -o bosh-deployment/gcp/cpi.yml \
    -o bosh-deployment/uaa.yml \
    -o bosh-deployment/credhub.yml \
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

bosh alias-env ${project_id} -e 10.0.0.6 --ca-cert <(bosh int director-creds.yml --path /director_ssl/ca)
eval $(./login.sh)

bosh upload-stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent
bosh update-cloud-config cloud-config.yml --non-interactive
