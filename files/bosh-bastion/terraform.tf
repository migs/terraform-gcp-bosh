data "terraform_remote_state" "%%PROJECT" {
  backend = "gcs"
  config {
    credentials = "%%SERVICE_ACCOUNT_ID-%%PROJECT.key.json"
    bucket = "%%PROJECT-terraform"
    project = "%%PROJECT"
  }
}
