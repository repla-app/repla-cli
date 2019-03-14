#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'shellwords'

# TODO: Add error handling

env=`env`
dir = Dir.pwd

script_arg = File.join(File.dirname(__FILE__), 'run_plugin.scpt')
command = "osascript #{script_arg} Server #{Shellwords.escape(dir)}"

arguments = ARGV[1..-1]
arguments.push(env)
command += ' ' + arguments.compact.map(&:to_s).map do |x|
  Shellwords.escape(x)
end.join(' ')

puts "command = #{command}"
