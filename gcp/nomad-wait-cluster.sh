#!/usr/bin/env bash
set -euo pipefail

function wait_for() {
  timeout=$1
  shift 1
  until [ $timeout -le 0 ] || ("$@" &>/dev/null); do
  #until [ $timeout -le 0 ] || ("$@"); do
    echo waiting for "$@"
    sleep 10
    timeout=$((timeout - 1))
  done
  if [ $timeout -le 0 ]; then
    return 1
  fi
}

function is_nomad_server_healthy() {
  local nomad_status=$(curl -s "$(terraform output  -json lb_address_consul_nomad | jq '.' -r):4646/v1/agent/health?type=server" | jq '.server.ok')

  if [ "${nomad_status}" = true ]; then
    return 0
  else
    return 1
  fi
}

function is_nomad_booted() {
  ./post-setup.sh
  if [ -f "nomad.token" ]; then
    return 0
  else
    return 1
  fi
}


if [ -f "nomad.token" ]; then
  echo "nomad.token found (did you terraform)"
fi


wait_for 20 is_nomad_server_healthy

NOMAD_CONSUL_SERVER_ADDR="$(terraform output  -json lb_address_consul_nomad | jq '.' -r)"
curl -s "${NOMAD_CONSUL_SERVER_ADDR}:4646/v1/agent/health?type=server" | jq

wait_for 20 is_nomad_booted
token="$(cat nomad.token)"

nomad node status -address="${NOMAD_CONSUL_SERVER_ADDR}:4646" -token="$token"

source ./nomad-env-info.sh

open "$(terraform output -raw lb_address_consul_nomad):4646"
open "$(terraform output -raw lb_address_consul_nomad):8500"


