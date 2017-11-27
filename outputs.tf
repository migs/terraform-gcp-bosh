output "bosh-bastion-hostname" {
  value = "${google_compute_instancebosh-bastion.name}"
}

output "bosh-bastion-public-ip" {
  value = "${google_compute_address.bosh-bastion-address.address}"
}
