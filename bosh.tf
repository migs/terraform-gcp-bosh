resource "google_compute_network" "bosh" {
  name = "${var.prefix}bosh"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "control-subnet-1" {
  name = "${var.prefix}control-${var.region}"
  ip_cidr_range = "${var.control-cidr}"
  network = "${google_compute_network.bosh.self_link}"
}

resource "google_compute_subnetwork" "ert-subnet-1" {
  name = "${var.prefix}ert-${var.region}"
  ip_cidr_range = "${var.ert-cidr}"
  network = "${google_compute_network.bosh.self_link}"
}

resource "google_compute_firewall" "bosh-bastion" {
  name = "${var.prefix}bosh-bastion"
  network = "${google_compute_network.bosh.name}"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  target_tags = ["bosh-bastion"]
}

resource "google_compute_firewall" "bosh-intra-subnet-open" {
  name = "${var.prefix}bosh-intra-subnet-open"
  network = "${google_compute_network.bosh.name}"

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_tags = ["internal"]
}

resource "google_compute_address" "bosh-bastion-address" {
  name = "${var.prefix}bosh-bastion-address"
}

resource "google_compute_instance" "bosh-bastion" {
  name = "${var.prefix}bosh-bastion"
  machine_type = "${var.bosh-machine_type}"
  zone = "${lookup(var.region_params["${var.region}"],"zone1")}"

  tags = ["bosh-bastion", "internal"]

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.control-subnet-1.name}"
    access_config {
      nat_ip = "${google_compute_address.bosh-bastion-address.address}"
    }
  }

  provisioner "file" {
    source = "../keys/automated-${var.project}.key.json"
    destination = "${var.home}/automated-${var.project}.key.json"
    connection {
      user = "vagrant"
    }
  }

  provisioner "file" {
    source = "files/bosh-bastion/"
    destination = "${var.home}/"
    connection {
      user = "vagrant"
      
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${var.home}/*.sh",
      "sed -i 's/%%PROJECT/${var.project}/' ${var.home}/terraform.tf",
      "sed -i 's/%%ENV/${var.prefix}/' ${var.home}/terraform.tf",
      "sed -i 's/%%ENV/${var.prefix}/' ${var.home}/cloud-config.yml",
    ]
    connection {
      user = "vagrant"
      private_key = "${var.ssh-privatekey == "" ? file("${var.home}/.ssh/google_compute_engine") : var.ssh-privatekey}"
    }
}


  metadata_startup_script = <<EOT
#!/bin/bash
cat > /etc/motd <<EOF




#    #     ##     #####    #    #   #   #    #    ####
#    #    #  #    #    #   ##   #   #   ##   #   #    #
#    #   #    #   #    #   # #  #   #   # #  #   #
# ## #   ######   #####    #  # #   #   #  # #   #  ###
##  ##   #    #   #   #    #   ##   #   #   ##   #    #
#    #   #    #   #    #   #    #   #   #    #    ####

Startup scripts have not finished running, and the tools you need
are not ready yet. Please log out and log back in again in a few moments.
This warning will not appear when the system is ready.
EOF

apt-get update
apt-get install -y git tree jq build-essential ruby ruby-dev openssl unzip

# install stackdriver
curl -O "https://repo.stackdriver.com/stack-install.sh"
sudo bash stack-install.sh --write-gcm

# install bosh2
curl -O https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${var.bosh-version}-linux-amd64
chmod +x bosh-cli-*
sudo mv bosh-cli-* /usr/local/bin/bosh

# install credhub cli
curl -OL https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${var.credhub-version}/credhub-linux-${var.credhub-version}.tgz
tar xvf credhub-linux-${var.credhub-version}.tgz
sudo mv credhub /usr/local/bin/credhub
rm -f credhub-linux-${var.credhub-version}.tgz

# install yaml
curl -OL https://github.com/mikefarah/yaml/releases/download/${var.yaml-version}/yaml_linux_amd64
chmod +x yaml*
sudo mv yaml* /usr/local/bin/yaml

# install terraform
curl -OL https://releases.hashicorp.com/terraform/${var.terraform-version}/terraform_${var.terraform-version}_linux_amd64.zip
unzip terraform_${var.terraform-version}_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform
rm -f terraform_${var.terraform-version}_linux_amd64.zip

cat > /etc/profile.d/bosh.sh <<'EOF'
#!/bin/bash
# Misc vars
export prefix=
export ssh_key_path=$HOME/.ssh/bosh

# Vars from Terraform
export subnetwork=${google_compute_subnetwork.control-subnet-1.name}
export network=${google_compute_network.bosh.name}

# Vars from metadata service
export project_id=$$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/project/project-id)
export zone=$$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone)
export zone=$${zone##*/}
export region=$${zone%-*}

# Configure gcloud
gcloud config set compute/zone $${zone}
gcloud config set compute/region $${region}

if [[ ! -d bosh-deployment ]]; then
    git clone https://github.com/cloudfoundry/bosh-deployment
fi

bosh -v
EOF

bosh upload-stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent
bosh ucc $HOME/cloud-config.yml

cat >> ${var.home}/.profile <<'EOF'
if [ -e director-creds.yml ]; then
    bosh alias-env $${project_id} -e $${var.director-ip} --ca-cert <(bosh int director-creds.yml --path /director_ssl/ca)
    eval $$(./login.sh)
fi
EOF

rm /etc/motd

EOT
}
