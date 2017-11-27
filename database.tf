module "bosh-db" {
  source = "github.com/migs/terraform-gcp-database"
  project = "${var.project}"
  region = "${var.region}"
  prefix = "${var.prefix}"
  ha = "${var.ha}"
  db-name = "bosh"
}
