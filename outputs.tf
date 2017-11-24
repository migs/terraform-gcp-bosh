output "nat-gateway-zone1-external_ip" {
  value = "${module.terraform-gcp-natgateway.nat-gateway-zone1-external_ip}"
}

output "nat-gateway-zone2-external_ip" {
  value = "${module.terraform-gcp-natgateway.nat-gateway-zone2-external_ip}"
}

output "nat-gateway-zone3-external_ip" {
  value = "${module.terraform-gcp-natgateway.nat-gateway-zone3-external_ip}"
}

output "bosh-bastion-external_ip" {
  value = "${google_compute_address.bosh-bastion-address.address}"
}
