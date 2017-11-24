data "terraform_remote_state" "%%PROJECT" {
  backend = "gcs"
  config {
    bucket = "%%PROJECT-terraform"
    project = "%%PROJECT"
    path = "%%ENV.tfstate"
  }
}

output "db-primary-ip" {
  value = "${data.terraform_remote_state.%%PROJECT.db-primary-ip}"
}

output "wordpress-password" {
  value = "${data.terraform_remote_state.%%PROJECT.wordpress-password}"
}

output "env" {
  value = "${data.terraform_remote_state.%%PROJECT.env}"
}

output "service_account_key" {
  value = "${data.terraform_remote_state.%%PROJECT.automated.private_key}"
}
