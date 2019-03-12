#!/usr/bin/env bash

set -e

plugin_name="$1"
dir=$PWD

env=$(env)
env_arg=$(printf %q $env)
