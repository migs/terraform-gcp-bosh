resource "google_service_account_key" "automated" {
  service_account_id = "${var.prefix}-${var.service_account_name}@${var.project}.iam.gserviceaccount.com"
}
