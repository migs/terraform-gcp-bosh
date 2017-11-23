/*
module "terraform-gcp-natgateway" {
  source = "github.com/migs/terraform-gcp-natgateway"
  project = "${var.project}"
  region = "${var.region}"
  prefix = "${var.prefix}"
  ha = "${var.ha}"
}
*/

module "nat-gateway-1" {
  source = "GoogleCloudPlatform/nat-gateway/google"
  region = "${var.region}"
  network = "${var.network}"
  zone = "${lookup(var.region_params["${var.region}"],zone1)}"
}

module "nat-gateway-2" {
  count = "${var.ha ? 1 : 0}"
  source = "GoogleCloudPlatform/nat-gateway/google"
  region = "${var.region}"
  network = "${var.network}"
  zone = "${lookup(var.region_params["${var.region}"],zone2)}"
}

module "nat-gateway-3" {
  count = "${var.ha ? 1 : 0}"
  source = "GoogleCloudPlatform/nat-gateway/google"
  region = "${var.region}"
  network = "${var.network}"
  zone = "${lookup(var.region_params["${var.region}"],zone3)}"
}
