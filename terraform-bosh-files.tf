data "template_file" "bosh-properties" {
  template = <<EOF
#!/usr/bin/env bash
export BOSH_DB_HOST=$${db-instance-ip}
export BOSH_DB_PORT=$${db-port}
export BOSH_DB_TYPE=$${db-type}
export BOSH_DB_ADAPTER=$${db-adapter}
export BOSH_DIRECTOR_IP=$${director-ip}
export GCP_CONTROL_CIDR=$${control-cidr}
export GCP_CONTROL_GW=$${control-gw}
export BOSH_DB_BOSH_PASSWORD=$${bosh-password}
export BOSH_DB_CREDHUB_PASSWORD=$${bosh-credhub-password}
export BOSH_DB_UAA_PASSWORD=$${bosh-uaa-password}
EOF
  vars {
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
  }
}
