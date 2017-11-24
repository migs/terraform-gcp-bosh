data "terraform_remote_state" "%%PROJECT" {
  backend = "gcs"
  config {
    credentials = "%%SERVICE_ACCOUNT_ID-%%PROJECT.key.json"
    bucket = "%%PROJECT-terraform"
    project = "%%PROJECT"
  }
}

output "workspace" {
  value = "${data.terraform_remote_state.stuart-finkit.workspace}"
}

output "service_account_key" {
  value = "${data.terraform_remote_state.stuart-finkit.service_account_key}"
  sensitive = true
}
