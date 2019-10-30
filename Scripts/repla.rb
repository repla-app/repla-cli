#!/usr/bin/env ruby --disable-gems

require 'shellwords'

usage = 'Usage: repla [plugin name (or) file] [plugin parameters]'

if ARGV[0].nil?
  warn usage
  exit 1
end

first_arg = ARGV[0]

if File.exist?(first_arg)
  if ARGV.length > 1
    warn usage
    exit 1
  end
  script_arg = File.join(__dir__, 'open.scpt')
  path = File.expand_path(first_arg)
  command = "/usr/bin/osascript \"#{script_arg}\" "\
    "\"#{Shellwords.escape(path)}\" '>/dev/null'"
  exec(command)
end

dir = Dir.pwd

script_arg = File.join(__dir__, 'run_plugin.scpt')
command = "/usr/bin/osascript \"#{script_arg}\" "\
  "\"#{Shellwords.escape(first_arg)}\" \"#{Shellwords.escape(dir)}\" >/dev/null"

arguments = ARGV[1..-1]
command += ' ' + arguments.compact.map(&:to_s).map do |x|
  Shellwords.escape(x)
end.join(' ')

exec(command)
