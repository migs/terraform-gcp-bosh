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
}

output "bosh-db-credhub-password" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-db-bosh-password}"
}

output "bosh-db-uaa-password" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-db-bosh-password}"
}

output "bosh-db-instance-ip" {
  value = "${data.terraform_remote_state.%%PROJECT.bosh-db-instance-ip}"
}
