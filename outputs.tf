output "bosh-bastion-hostname" {
  value = "${google_compute_instance.bosh-bastion.name}"
}

output "bosh-bastion-public-ip" {
  value = "${google_compute_address.bosh-bastion-address.address}"
}

output "bosh-db-bosh-password" {
  value = "${random_string.bosh-password.result}"
  sensitive = true
}

output "bosh-db-uaa-password" {
  value = "${random_string.bosh-uaa-password.result}"
  sensitive = true
}

output "bosh-db-credhub-password" {
  value = "${random_string.bosh-credhub-password.result}"
  sensitive = true
}

output "nat-gateway-ips" {
  value = "${module.terraform-gcp-natgateway.nat-gateway-ips}"
}
