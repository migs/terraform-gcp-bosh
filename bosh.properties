data "template_file" "bosh-properties" {
  template = <<EOF
#!/usr/bin/env bash
export BOSH_DB_HOST=$${module.bosh-db.db-instance-ip}
export BOSH_DB_PORT=$${lookup(var.database_params["port"], var.db-version)}
export BOSH_DB_TYPE=$${lookup(var.database_params["type"], var.db-version)}
export BOSH_DB_ADAPTER=$${lookup(var.database_params["bosh-adapter"], var.db-version)}
export BOSH_DIRECTOR_IP=$${var.director-ip}
export GCP_CONTROL_CIDR=$${var.control-cidr}
export GCP_CONTROL_GW=$${var.control-gw}
export GCP_ENV=$${var.prefix}
export BOSH_DB_BOSH_PASSWORD=$${random_string.bosh-password.result}
export BOSH_DB_CREDHUB_PASSWORD=$${random_string.bosh-credhub-password.result}
export BOSH_DB_UAA_PASSWORD=$${random_string.bosh-uaa-password.result}
EOF
}
