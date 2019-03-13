#!/usr/bin/env bash

set -e

bundle_name="$1"

if [[ -z "$bundle_name" ]]; then
  echo "Error no bundle name specified." >&2
  exit 1
fi

if [[ "$bundle_name" = "Server" ]]; then
  echo "The only the Server bundle is currently supported." >&2
  exit 1
fi

if [[ -n "$2" ]]; then
  dir="$2"
else
  dir=$PWD
fi

env=$(env)
env_arg=$(printf %q $env)

osascript "${BASH_SOURCE%/*}/run_plugin.scpt" $dir $@ $env_arg
