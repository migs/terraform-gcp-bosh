#!/bin/bash -eu

GCP_ENV=%%ENV

# Extract variables from terraform state
terraform refresh
BOSH_DB_HOST=$(terraform output bosh-db-instance-ip)
BOSH_DB_TYPE=$(terraform output bosh-db-type)
BOSH_DB_ADAPTER=$(terraform output bosh-db-adapter)
BOSH_DB_BOSH_PASSWORD=$(terraform output bosh-db-bosh-password)
BOSH_DB_CREDHUB_PASSWORD=$(terraform output bosh-db-credhub-password)
BOSH_DB_UAA_PASSWORD=$(terraform output bosh-db-uaa-password)
BOSH_DIRECTOR_IP=$(terraform output bosh-director-ip)
GCP_CONTROL_CIDR=$(terraform output bosh-control-cidr)
GCP_CONTROL_GW=$(terraform output bosh-control-gw)

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
    -o bosh-deployment/misc/external-db.yml \
    -o bosh-support/bosh-uaa-credhub-external-db.yml \
    -v external_db_host=${BOSH_DB_HOST} \
    -v external_db_adapter=${BOSH_DB_ADAPTER} \
    -v external_db_name="bosh_db"
    -v external_db_user="bosh"
    -v external_db_password=${BOSH_DB_BOSH_PASSWORD} \
    -v external_db_credhub_name="bosh_credhub_db"
    -v external_db_credhub_user="bosh_credhub"
    -v external_db_credhub_password=${BOSH_DB_CREDHUB_PASSWORD} \
    -v external_db_credhub_type=${BOSH_DB_TYPE}
    -v external_db_uaa_name="bosh_uaa_db"
    -v external_db_uaa_user="bosh_uaa"
    -v external_db_uaa_password=${BOSH_DB_UAA_PASSWORD} \
    -v external_db_uaa_type=${BOSH_DB_TYPE}
    -v director_name=${GCP_PROJECT} \
    -v internal_cidr=${GCP_CONTROL_CIDR} \
    -v internal_gw=${GCP_CONTROL_GW} \
    -v internal_ip=${BOSH_DIRECTOR_IP} \
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
    -o bosh-deployment/misc/external-db.yml \
    -o bosh-support/bosh-uaa-credhub-external-db.yml \
    -v external_db_host=${BOSH_DB_HOST} \
    -v external_db_password=${BOSH_DB_BOSH_PASSWORD} \
    -v external_db_credhub_password=${BOSH_DB_CREDHUB_PASSWORD} \
    -v external_db_uaa=${BOSH_DB_UAA_PASSWORD} \
    -v director_name=${GCP_PROJECT} \
    -v internal_cidr=${GCP_CONTROL_CIDR} \
    -v internal_gw=${GCP_CONTROL_GW} \
    -v internal_ip=${BOSH_DIRECTOR_IP} \
    --var-file  gcp_credentials_json=${SERVICE_ACCOUNT}.key.json \
    -v project_id=${GCP_PROJECT} \
    -v zone=${GCP_ZONE} \
    -v tags=[internal,no-ip] \
    -v network=${GCP_NETWORK} \
    -v subnetwork=${GCP_SUBNETWORK}

bosh alias-env ${project_id} -e 10.0.0.6 --ca-cert <(bosh int director-creds.yml --path /director_ssl/ca)
eval $(./login.sh)

bosh upload-stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent
bosh update-cloud-config cloud-config.yml --non-interactive
