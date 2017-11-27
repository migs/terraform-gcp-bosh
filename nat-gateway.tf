module "terraform-gcp-natgateway" {
  source = "github.com/migs/terraform-gcp-natgateway"
  project = "${var.project}"
  region = "${var.region}"
  prefix = "${var.prefix}"
  zones = "${var.zones}"
  network = "${google_compute_network.bosh.name}"
  subnetwork = "${google_compute_subnetwork.control-subnet-1.name}"
}
