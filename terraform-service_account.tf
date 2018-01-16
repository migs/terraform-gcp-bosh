resource "google_service_account_key" "automated" {
  service_account_id = "${var.service_account_name}.iam.gserviceaccount.com"
}
