output "bosh-bastion-hostname" {
  value = "${google_compute_instance.bosh-bastion.name}"
}

output "bosh-bastion-public-ip" {
  value = "${google_compute_address.bosh-bastion-address.address}"
}

output "bosh-db-instance-name" {
  value = "${module.bosh-db.db-instance-name}"
}

output "bosh-db-instance-ip" {
  value = "${module.bosh-db.db-instance-ip}"
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

output "bosh-director-ip" {
  value = "${var.director-ip}"
}

output "bosh-control-cidr" {
  value = "${var.control-cidr}"
}

output "bosh-control-gw" {
  value = "${var.control-gw}"
}
