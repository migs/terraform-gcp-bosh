variable "project" { }
variable "region" { }
variable "prefix" { default = "default" }
variable "network" { default = "default" }
variable "image" { default = "ubuntu-1604-lts" }
variable "stackdriver-version" { default = "1.0.2" }
variable "bosh-version" { default = "2.0.45" }
variable "credhub-version" { default = "1.5.3" }
variable "safe-version" { default = "0.6.2" }
variable "terraform-version" { default = "0.11.1" }
variable "fly-version" { default = "3.8.0" }
variable "yaml-version" { default = "1.13.1" }
variable "vault-version" { default = "0.9.1" }
variable "home" { default = "/home/vagrant" }
variable "control-cidr" { default = "10.0.0.0/24" }
variable "control-gw" { default = "10.0.0.1" }
variable "ert-cidr" { default = "10.10.0.0/22" }
variable "director-ip" { default = "10.0.0.6" }
variable "service_account_name" { default = "automated" }
variable "bosh-machine_type" { default = "f1-micro" }
variable "ssh-privatekey" { default = "" }
variable "db-version" { default = "MYSQL_5_7" }
variable "db-tier" { default = "db-g1-small" }
variable "db-ha" { default = false }

# Pass-Through variables for `terraform-gcp-natgateway`
variable "zones" { default = "1" }
variable "nat-gateway-image" { default = "debian-cloud/debian-8" }
variable "nat-gateway-machine_type" { default = "f1-micro" }
variable "squid_enabled" { default = false }
variable "squid_config" { default = "" }
variable "tags" { default = ["nat","internal"] }
variable "priority" { default = "800" }
variable "route-tag" { default = "no-ip" }

# Database Map
variable "database_params" {
  type = "map"
  default {
    type {
      MYSQL_5_7 = "mysql"
      POSTGRES_9_6 = "postgres"
    }
    bosh-adapter {
      MYSQL_5_7 = "mysql2"
      POSTGRES_9_6 = "postgres"
    }
    port {
      MYSQL_5_7 = "3306"
      POSTGRES_9_6 = "5432"
    }
    charset {
      MYSQL_5_7 = "utf8"
      POSTGRES_9_6 = "UTF8"
    }
    collation {
      MYSQL_5_7 = "utf8_general_ci"
      POSTGRES_9_6 = "en_US.UTF8"
    }
  }
}

# Region & Zone Map
variable "region_params" {
  type = "map"
  default {
    asia-east1 {
      zone1 = "asia-east1-a"
      zone2 = "asia-east1-b"
      zone3 = "asia-east1-c"
    }
    asia-northeast1 {
      zone1 = "asia-northeast1-a"
      zone2 = "asia-northeast1-b"
      zone3 = "asia-northeast1-c"
    }
    asia-south1 {
      zone1 = "asia-south1-a"
      zone2 = "asia-south1-b"
      zone3 = "asia-south1-c"
    }
    asia-southeast1 {
      zone1 = "asia-southeast1-a"
      zone2 = "asia-southeast1-b"
    }
    australia-southeast1 {
      zone1 = "australia-southeast1-a"
      zone2 = "australia-southeast1-b"
      zone3 = "australia-southeast1-c"
    }
    europe-west1 {
      zone1 = "europe-west1-b"
      zone2 = "europe-west1-c"
      zone3 = "europe-west1-d"
    }
    europe-west2 {
      zone1 = "europe-west2-a"
      zone2 = "europe-west2-b"
      zone3 = "europe-west2-c"
    }
    europe-west3 {
      zone1 = "europe-west3-a"
      zone2 = "europe-west3-b"
      zone3 = "europe-west3-c"
    }
    southamerica-east1 {
      zone1 = "southamerica-east1-a"
      zone2 = "southamerica-east1-b"
      zone3 = "southamerica-east1-c"
    }
    us-central1 {
      zone1 = "us-central1-a"
      zone2 = "us-central1-b"
      zone3 = "us-central1-c"
      zone4 = "us-central1-f"
    }
    us-east1 {
      zone1 = "us-east1-b"
      zone2 = "us-east1-c"
      zone3 = "us-east1-d"
    }
    us-east4 {
      zone1 = "us-east4-a"
      zone2 = "us-east4-b"
      zone3 = "us-east4-c"
    }
    us-west1 {
      zone1 = "us-west1-a"
      zone2 = "us-west1-b"
      zone3 = "us-west1-c"
    }
  }
}
