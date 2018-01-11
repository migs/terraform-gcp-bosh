output "bosh-bastion-hostname" {
  value = "${google_compute_instance.bosh-bastion.name}"
}

output "bosh-bastion-public-ip" {
  value = "${google_compute_instance.bosh-bastion.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "nat-gateway-ips" {
  value = "${module.terraform-gcp-natgateway.nat-gateway-ips}"
}

output "bosh-network-link" {
  value = "${google_compute_network.bosh.self_link}"
}

output "db-instance-name" {
  value = "${module.bosh-db.db-instance-name}"
}
