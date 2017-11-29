# Google Cloud Platform BOSH Bastion & NAT Gateway Terraform Module

A Terraform Module for creating a BOSH Bastion preloaded with the scripts required to build a BOSH Director, using the ['bosh-deployment'](https://github.com/cloudfoundry/bosh-deployment) repo. This BOSH bastion will be configured with an external Cloud SQL database.

This module uses the ['terraform-gcp-natgateway'](https://github.com/migs/terraform-gcp-natgateway) module to provide the NAT Gateway configuration.
This module uses the ['terraform-gcp-database'](https://github.com/migs/terraform-gcp-database) module to provide the Cloud SQL database.

## Usage

```
module "terraform-gcp-bosh" {
  source = "github.com/migs/terraform-gcp-bosh"
  project = "${var.project}"
  region = "${var.region}"
}
```

In the above example, a service-account named `automated` is created with the `roles/owner` role. This is used to pre-load your bosh-bastion with a service-account key which is ready to be used to create your bosh director. The name and role can be overridden where required.

## High Availability

By passing the `ha` variable as `true`, an additional failover instance of the Bosh Database will be created.
By passing the `zones` variable, you can specify how many NAT Gateways are created (one per zone for a given region).

## Variables

See `variables.tf` for a complete list of variables that can be overridden as required.

## Outputs

The following outputs are defined:

`bosh-bastion-hostname`
`bosh-bastion-public-ip`
`nat-gateway-ips`
