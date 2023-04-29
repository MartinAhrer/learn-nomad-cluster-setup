#!/usr/bin/env sh
echo
echo "Set the environment with management token"
echo "The bootstrap token is '$(cat nomad_bootstrap.token)'"
echo 'export NOMAD_ADDR=$(terraform output -raw lb_address_consul_nomad):4646'
echo 'export NOMAD_TOKEN=$(cat nomad_bootstrap.token)'
echo "nomad ui -authenticate"

echo
echo "Set the environment with user token"
echo "The user token is '$(cat nomad.token)'"
echo 'export NOMAD_ADDR=$(terraform output -raw lb_address_consul_nomad):4646'
echo 'export NOMAD_TOKEN=$(cat nomad.token)'
echo "nomad ui -authenticate"
echo
echo "Open the nomad ui with $(terraform output -raw lb_address_consul_nomad):4646 and authenticate with one of the tokens"
