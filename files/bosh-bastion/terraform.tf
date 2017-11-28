data "terraform_remote_state" "%%PROJECT" {
  backend = "gcs"
  config {
    credentials = "%%SERVICE_ACCOUNT_ID-%%PROJECT.key.json"
    bucket = "%%PROJECT-terraform"
    project = "%%PROJECT"
  }
}

output "bosh-db-bosh-password" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-db-bosh-password}"
  sensitive = true
}

output "bosh-db-credhub-password" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-db-credhub-password}"
  sensitive = true
}

output "bosh-db-uaa-password" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-db-uaa-password}"
  sensitive = true
}

output "bosh-db-instance-ip" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-db-instance-ip}"
}

output "bosh-director-ip" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-director-ip}"
}

output "bosh-control-cidr" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-control-cidr}"
}

output "bosh-control-gw" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-control-gw}"
}
