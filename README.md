# Google Cloud Platform BOSH Bastion & NAT Gateway Terraform Module

A Terraform Module for creating a BOSH Bastion preloaded with the scripts required to build a BOSH Director, using the ['bosh-deployment'](https://github.com/cloudfoundry/bosh-deployment) repo.

This module uses the ['terraform-gcp-natgateway'](https://github.com/migs/terraform-gcp-natgateway) module to provide the NAT Gateway configuration.

## Usage

```
module "terraform-gcp-bosh" {
  source = "github.com/migs/terraform-gcp-bosh"
  project = "${var.project}"
  region = "${var.region}"
}
```

In the above example, a service-account named `automated` is created with the `roles/owner` role. This is used to pre-load your bosh-bastion with a service-account key which is ready to be used to create your bosh director. The name and role can be overridden where required.
