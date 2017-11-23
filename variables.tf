variable "project" { }
variable "region" { }
variable "prefix" { default = "default" }
variable "ha" { default = "false" }
variable "network" { default = "default" }
variable "region_params" {
  type = "map"
  default {
    europe-west1 {
      zone1 = "europe-west1-b"
      zone2 = "europe-west1-c"
      zone3 = "europe-west1-d"
    }
    europe-west1 {
      zone1 = "europe-west2-a"
      zone2 = "europe-west2-b"
      zone3 = "europe-west2-c"
    }
  }
}
variable "image" { default = "ubuntu-1604-lts" }
variable "bosh-version" { default = "2.0.45" }
variable "credhub-version" { default = "1.6.4" }
variable "terraform-version" { default = "0.11.0" }
variable "yaml-version" { default = "1.13.1" }
variable "home" { default = "/home/vagrant" }
variable "control-cidr" { default = "10.0.0.0/24" }
variable "ert-cidr" { default = "10.10.0.0/22" }
variable "director-ip" { default = "10.0.0.6" }
variable "service_account_email" { default = "automated@finkit-website.iam.gserviceaccount.com" }
variable "bosh-machine_type" { default = "f1-micro" }
