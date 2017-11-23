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
