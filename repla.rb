#!/usr/bin/env ruby

require 'repla'

PLUGIN_NAME = "Server"

command = ARGV[0]
directory = Dir.pwd

Repla::run_plugin(PLUGIN_NAME, directory, [term])
