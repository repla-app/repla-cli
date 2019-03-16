#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'shellwords'

if ARGV[0].nil?
  STDERR.puts "Error no bundle name specified."
  exit 1
end

if ARGV[0] != "server"
  STDERR.puts "The only the Server bundle is currently supported."
  exit 1
end

if ARGV[1].nil?
  STDERR.puts "No command specified."
  exit 1
end

env=`env`
dir = Dir.pwd

script_arg = File.join(File.dirname(__FILE__), 'run_plugin.scpt')
command = "osascript #{script_arg} Server #{Shellwords.escape(dir)}"

arguments = ARGV[1..-1]
arguments.push(env)
command += ' ' + arguments.compact.map(&:to_s).map do |x|
  Shellwords.escape(x)
end.join(' ')

`#{command}`
