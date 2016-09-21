#! /usr/bin/env ruby
require 'fileutils'

def usage()
  puts "This script will just force remove all dependencies of a module."
  puts "This will let you install it fresh and let it pull the dependencies it needs."
  puts
  puts "    dependency_nuke.rb puppetlabs/windows [--modulepath /etc/puppetlabs/code-staging/modules]"
end

usage() unless [1,3].include? ARGV.size

mod = ARGV.shift
IO.popen("puppet module install #{mod} --modulepath /tmp/nuker --debug").readlines.each do |line|
  next unless line =~ /Debug: HTTP GET.*module=(\w*-\w*)/

  puts "Uninstalling #{$1}..."
  system("puppet module uninstall #{$1} #{ARGV.join(' ')} --force > /dev/null 2>&1")
end

FileUtils.rm_rf '/tmp/nuker'
puts
puts "Now try installing #{mod} again and see if dependencies are properly resolved."
puts "- You may need to reinstall modules that were removed."
