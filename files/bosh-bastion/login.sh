#!/bin/bash -eu

echo 'export BOSH_CLIENT=admin'
echo 'export BOSH_CLIENT_SECRET=`bosh int director-creds.yml --path /admin_password`'
echo 'export BOSH_ENVIRONMENT=10.0.0.6'
