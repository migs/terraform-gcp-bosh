variable "project" { }
variable "region" { }
variable "image" { default = "debian-cloud/debian-8" }
variable "machine_type" { default = "f1-micro" }
variable "prefix" { default = "nat-gateway-" }
variable "squid_enabled" { default = false }
variable "squid_config" { default = "" }
variable "network" { default  = "default" }
variable "subnetwork" { default  = "default" }
variable "service_account_email" { default = "default" }
variable "service_account_scopes" { default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control",
    ]}
variable "nat-gateway-hc-name" { default = "http" }
variable "nat-gateway-hc-port" { default = "80" }
variable "nat-gateway-hc-path" { default = "/" }
variable "nat-gateway-hc-initial_delay" { default = "300" }
variable "nat-gateway-hc-interval" { default = "30" }
variable "nat-gateway-hc-timeout" { default = "10" }
variable "nat-gateway-hc-healthy_threshold" { default = "1" }
variable "nat-gateway-hc-unhealthy_threshold" { default = "10" }
variable "target_tags" { default = "nat" }
variable "ha" { default = false }
