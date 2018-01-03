module "bosh-db" {
  source = "github.com/migs/terraform-gcp-database"
  project = "${var.project}"
  region = "${var.region}"
  prefix = "${var.prefix}"
  ha = "${var.db-ha}"
  db-instance-name = "bosh"
  authorized_networks = "${module.terraform-gcp-natgateway.nat-gateway-ips["0"]}"
}

resource "google_sql_database" "bosh_db" {
  name = "bosh_db"
  instance = "${module.bosh-db.db-instance-name}"
  charset = "${lookup(var.database_params["charset"],var.db-version)}"
  collation = "${lookup(var.database_params["collation"],var.db-version)}"
}

resource "google_sql_database" "bosh_uaa_db" {
  name = "bosh_uaa_db"
  instance = "${module.bosh-db.db-instance-name}"
  charset = "${lookup(var.database_params["charset"],var.db-version)}"
  collation = "${lookup(var.database_params["collation"],var.db-version)}"
}

resource "google_sql_database" "bosh_credhub_db" {
  name = "bosh_credhub_db"
  instance = "${module.bosh-db.db-instance-name}"
  charset = "${lookup(var.database_params["charset"],var.db-version)}"
  collation = "${lookup(var.database_params["collation"],var.db-version)}"
}

resource "random_string" "bosh-password" {
  length = 16
  special = false
}

resource "google_sql_user" "bosh" {
  name = "bosh"
  instance = "${module.bosh-db.db-instance-name}"
  host = "%"
  password = "${random_string.bosh-password.result}"
}

resource "random_string" "bosh-uaa-password" {
  length = 16
  special = false
}

resource "google_sql_user" "bosh_uaa" {
  name = "bosh_uaa"
  instance = "${module.bosh-db.db-instance-name}"
  host = "%"
  password = "${random_string.bosh-uaa-password.result}"
}

resource "random_string" "bosh-credhub-password" {
  length = 16
  special = false
}

resource "google_sql_user" "bosh_credhub" {
  name = "bosh_credhub"
  instance = "${module.bosh-db.db-instance-name}"
  host = "%"
  password = "${random_string.bosh-credhub-password.result}"
}
