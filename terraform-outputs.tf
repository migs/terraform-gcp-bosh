output "bosh-bastion-hostname" {
  value = "${google_compute_instance.bosh-bastion.name}"
}

output "bosh-bastion-public-ip" {
  value = "${google_compute_address.bosh-bastion-address.address}"
}

output "nat-gateway-ips" {
  value = "${module.terraform-gcp-natgateway.nat-gateway-ips}"
}

output "bosh-network-link" {
  value = "${google_compute_network.bosh.self_link}"
}
