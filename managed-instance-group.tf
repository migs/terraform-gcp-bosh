resource "google_compute_instance_template" "nat-gateway" {
  disk {
    boot = true
    source_image = "${var.image}"
    type = "PERSISTENT"
    disk_type = "pd-ssd"
  }
  machine_type = "${var.machine_type}"
  name_prefix = "${var.prefix}"
  can_ip_forward = true
  metadata = "${map("startup-script", "${data.template_file.nat-gateway_startup-script.rendered}")}"
  network_interface {
    network = "${var.network}"
    subnetwork = "${var.subnetwork}"
  }
  service_account {
    email  = "${var.service_account_email}"
    scopes = ["${var.service_account_scopes}"]
  }
  tags = ["internal","nat"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "nat-gateway" {
  name = "${var.prefix}nat-gateway"
  base_instance_name = "${var.prefix}nat-gateway-"
  instance_template = "${google_compute_instance_template.nat-gateway.self_link}"
  auto_healing_properties {
    health_check = "${google_compute_health_check.nat-gateway.self_link}"
    initial_delay_sec = "${var.nat-gateway-hc-initial_delay}"
  }
  named_port {
    name = "${var.nat-gateway-hc-name}"
    port = "${var.nat-gateway-hc-port}"
  }
  target_size = "${var.ha ? 3 : 1}"
}

resource "google_compute_health_check" "nat-gateway" {
  name = "${var.prefix}nat-gateway"
  check_interval_sec  = "${var.nat-gateway-hc-interval}"
  timeout_sec         = "${var.nat-gateway-hc-timeout}"
  healthy_threshold   = "${var.nat-gateway-hc-healthy_threshold}"
  unhealthy_threshold = "${var.nat-gateway-hc-unhealthy_threshold}"
  http_health_check {
    port = "${var.nat-gateway-hc-port}"
    request_path = "${var.nat-gateway-hc-path}"
  }
}

resource "google_compute_firewall" "nat-gateway" {
  network = "${var.network}"
  name = "${var.prefix}nat-gateway-health-check"
  allow {
    protocol = "tcp"
    ports = "${var.nat-gateway-hc-port}"
  }
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["${var.target_tags}"]
}
