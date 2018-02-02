module "terraform-gcp-natgateway" {
  source = "github.com/migs/terraform-gcp-natgateway"
  project = "${var.project}"
  region = "${var.region}"
  zones = "${var.zones}"
  network = "${google_compute_network.bosh.name}"
  subnetwork = "${google_compute_subnetwork.control-subnet-1.name}"
  nat-gateway-machine_type = "${var.nat-gateway-machine_type}"
}
