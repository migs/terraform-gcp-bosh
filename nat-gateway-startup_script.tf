data "template_file" "nat-gateway_startup-script" {
  template = <<EOF
#!/bin/bash -xe
# Enable ip forwarding and nat
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
apt-get update
# Install nginx for instance http health check
apt-get install -y nginx
ENABLE_SQUID="${var.squid_enabled}"
if [[ "$ENABLE_SQUID" == "true" ]]; then
  apt-get install -y squid3
  cat - > /etc/squid3/squid.conf <<'EOM'
${file("${var.squid_config == "" ? "${format("%s/config/squid.conf", path.module)}" : var.squid_config}")}
EOM
  systemctl reload squid3
fi
EOF
}
