resource "google_service_account" "automated" {
  project = "${var.project}"
  account_id = "${var.service_account_name}"
  display_name = "Automated Service Account"
}

resource "google_project_iam_policy" "automated" {
  project = "${var.project}"
  policy_data = "${data.google_iam_policy.automated.policy_data}"
}

data "google_iam_policy" "automated" {
  binding {
    role = "${var.service_account_role}"
     members = [
    "serviceAccount:${google_service_account.automated.email}",
    ]
  }
}

resource "google_service_account_key" "automated" {
  service_account_id = "${google_service_account.automated.id}"
}

output "service_account" {
  value = "${google_service_account.automated.account_id}"
}

output "service_account_key" {
  value = "${google_service_account_key.automated.private_key}"
  sensitive = true
}
