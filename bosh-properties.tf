data "template_file" "bosh-properties" {
  template = <<EOF
#!/usr/bin/env bash
export BOSH_DB_HOST=$${db-instance-ip}
export BOSH_DB_PORT=$${db-port}
export BOSH_DB_TYPE=$${db-type}
export BOSH_DB_ADAPTER=$${db-adapter}
export BOSH_DIRECTOR_IP=$${var.director-ip}
export GCP_CONTROL_CIDR=$${var.control-cidr}
export GCP_CONTROL_GW=$${var.control-gw}
export GCP_ENV=$${var.prefix}
export BOSH_DB_BOSH_PASSWORD=$${random_string.bosh-password.result}
export BOSH_DB_CREDHUB_PASSWORD=$${random_string.bosh-credhub-password.result}
export BOSH_DB_UAA_PASSWORD=$${random_string.bosh-uaa-password.result}
EOF
  vars {
    db-instance-ip = "${module.bosh-db.db-instance-ip}"
    db-port = "${lookup(var.database_params["port"], var.db-version)}"
    db-type = "${lookup(var.database_params["type"], var.db-version)}"
    db-adapter = "${lookup(var.database_params["bosh-adapter"], var.db-version)}"
  }
}
