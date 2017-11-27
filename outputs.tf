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
