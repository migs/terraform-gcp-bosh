data "template_file" "runtime-config" {
  template = <<EOF
releases:
- {name: stackdriver-tools, version: $${stackdriver-version}} 

addons:
- name: stackdriver
  jobs:
  - name: google-fluentd
    release: stackdriver-tools
  - name: stackdriver-agent
    release: stackdriver-tools
EOF
  vars {
    stackdriver-version = "${var.stackdriver-version}"
    project = "${var.project}"
  }
}

data "template_file" "create-bosh" {
  template = <<EOF
#!/usr/bin/env bash

set -e

if [[ ! -d bosh-deployment ]]; then
    git clone https://github.com/cloudfoundry/bosh-deployment
else
    cd bosh-deployment
    git pull
    cd ..
fi

for file in director-creds.yml director-state.json; do
    if [[ ! -f $file ]]; then
        if [[ $(gsutil ls gs://$${project}-bosh-state/$file) ]]; then
            gsutil cp gs://$${project}-bosh-state/$file .
        fi
    fi
done

bosh create-env bosh-deployment/bosh.yml \
    --state=director-state.json \
    --vars-store=director-creds.yml \
    -o bosh-deployment/gcp/cpi.yml \
    -o bosh-deployment/uaa.yml \
    -o bosh-deployment/credhub.yml \
    -o bosh-deployment/misc/external-db.yml \
    -o bosh-support/bosh-uaa-credhub-external-db.yml \
    -v external_db_host=$${db-instance-ip} \
    -v external_db_port=$${db-port} \
    -v external_db_adapter=$${db-adapter} \
    -v external_db_name="bosh_db" \
    -v external_db_user="bosh" \
    -v external_db_password=$${bosh-password} \
    -v external_db_credhub_name="bosh_credhub_db" \
    -v external_db_credhub_user="bosh_credhub" \
    -v external_db_credhub_password=$${bosh-credhub-password} \
    -v external_db_credhub_type=$${db-type} \
    -v external_db_uaa_name="bosh_uaa_db" \
    -v external_db_uaa_user="bosh_uaa" \
    -v external_db_uaa_password=$${bosh-uaa-password} \
    -v external_db_uaa_type=$${db-type} \
    -v director_name=$${project} \
    -v internal_cidr=$${control-cidr} \
    -v internal_gw=$${control-gw} \
    -v internal_ip=$${director-ip} \
    --var-file  gcp_credentials_json=$${service-account}.key.json \
    -v project_id=$${project} \
    -v zone=$${zone} \
    -v tags=[internal,no-ip] \
    -v network=$${network} \
    -v subnetwork=$${subnetwork}

bosh alias-env $${project} -e $${director-ip} --ca-cert <(bosh int director-creds.yml --path /director_ssl/ca)
eval $(./login.sh)

bosh upload-stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent
bosh upload-release https://github.com/cloudfoundry-community/stackdriver-tools/releases/download/v$${stackdriver-version}/stackdriver-tools-$${stackdriver-version}.tgz --non-interactive
bosh update-cloud-config cloud-config.yml --non-interactive
bosh update-runtime-config runtime-config.yml --non-interactive

gsutil cp director-state.json gs://$${project}-bosh-state/
gsutil cp director-creds.yml gs://$${project}-bosh-state/

set +e
EOF
  vars {
    project = "${var.project}"
    zone = "${lookup(var.region_params["${var.region}"],"zone1")}"
    network = "${google_compute_network.bosh.name}"
    subnetwork = "${google_compute_subnetwork.control-subnet-1.name}"
    service-account = "${var.service_account_name}-${var.project}"
    db-instance-ip = "${module.bosh-db.db-instance-ip}"
    db-port = "${lookup(var.database_params["port"], var.db-version)}"
    db-type = "${lookup(var.database_params["type"], var.db-version)}"
    db-adapter = "${lookup(var.database_params["bosh-adapter"], var.db-version)}"
    director-ip = "${var.director-ip}"
    control-cidr = "${var.control-cidr}"
    control-gw = "${var.control-gw}"
    bosh-password = "${random_string.bosh-password.result}"
    bosh-credhub-password = "${random_string.bosh-credhub-password.result}"
    bosh-uaa-password = "${random_string.bosh-uaa-password.result}"
    stackdriver-version = "${var.stackdriver-version}"
  }
}

data "template_file" "delete-bosh" {
  template = <<EOF
#!/usr/bin/env bash

set -e

bosh delete-env bosh-deployment/bosh.yml \
    --state=director-state.json \
    --vars-store=director-creds.yml \
    -o bosh-deployment/gcp/cpi.yml \
    -v director_name=$${project} \
    -v internal_cidr=$${control-cidr} \
    -v internal_gw=$${control-gw} \
    -v internal_ip=$${director-ip} \
    --var-file  gcp_credentials_json=$${service-account}.key.json \
    -v project_id=$${project} \
    -v zone=$${zone} \
    -v tags=[internal,no-ip] \
    -v network=$${network} \
    -v subnetwork=$${subnetwork}

for file in director-state.json director-creds.yml; do
    rm -f $file
    gsutil rm gs://$${project}-bosh-state/$file
done
EOF
  vars  {
    project = "${var.project}"
    zone = "${lookup(var.region_params["${var.region}"],"zone1")}"
    network = "${google_compute_network.bosh.name}"
    subnetwork = "${google_compute_subnetwork.control-subnet-1.name}"
    service-account = "${var.service_account_name}-${var.project}"
    director-ip = "${var.director-ip}"
    control-cidr = "${var.control-cidr}"
    control-gw = "${var.control-gw}"
  }
}
