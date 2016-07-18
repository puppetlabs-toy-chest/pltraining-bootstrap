#! /usr/bin/env ruby
require 'optparse'

force = false
optparse = OptionParser.new do |opts|
    opts.banner = "Usage: #{File.basename $0} [service name] [service name] ... [-f] [-h]

This script simply helps restart the PE services in the right order.
It will send a HUP signal to Puppetserver by default which is much
faster than a full restart.

If you do need the full restart, please pass the -f option.

Service names:
    * puppetserver
    * console
    * puppetdb
    * orchestration
    * mcollective
    * all (restart all services in the proper order)

Examples:
    * restart_pe_services.rb puppetdb puppetserver
    * restart_pe_services.rb puppetserver console -f
    * restart_pe_services.rb all -f

"

    opts.on("-f", "--force", "Force a hard restart.") do
      force = true
    end

    opts.on("-h", "--help", "Displays this help") do
        puts opts
        puts
        exit
    end
end
optparse.parse!

def restart(service)
  puts "- Restarting #{service}..."
  system("systemctl restart #{service}")
end

def reload(service, pattern)
  puts "> Reloading #{service}..."
  system("kill -HUP `pgrep -f #{pattern}`")
end

########################### start execution #########################
if ARGV.empty?
  puts "Run with --help for usage notes."
  exit 1
end
ARGV.map! { |x| x.downcase }

if ARGV.include? 'all'
  puts "Restarting all PE stack services. This may take a few minutes..."
  ARGV.concat ['puppetdb', 'puppetserver', 'orchestrator', 'console', 'mcollective', 'puppet']
  ARGV.uniq!
else
  puts "Restarting selected PE components."
end

if ARGV.grep(/puppetdb|pdb/).any?
  restart('pe-postgresql.service')
  restart('pe-puppetdb.service')
end

if ARGV.grep(/puppetserver|server/).any?
  if force
    restart('pe-puppetserver.service')
  else
    reload('pe-puppetserver.service', 'puppet-server')
  end
end

if ARGV.grep(/orch|pxp/).any?
  restart('pe-orchestration-services.service')
  restart('pxp-agent.service')
end

if ARGV.grep(/console/).any?
  restart('pe-console-services.service')
  restart('pe-nginx.service')
end

if ARGV.grep(/mco/).any?
  restart('pe-activemq.service')
  restart('mcollective.service')
end

if ARGV.include? 'puppet'
  restart('puppet.service')
end
