#!/usr/bin/env bash

set -e

bundle_name="$1"

if [[ -z "$bundle_name" ]]; then
  echo "Error no bundle name specified" >&2
  exit 1
fi

dir=$PWD
env=$(env)
env_arg=$(printf %q $env)
