#!/opt/puppetlabs/puppet/bin/ruby

require 'json'
require 'yaml'
require 'net/http'
require 'openssl'
require 'puppet'
require 'socket'

class SimplePuppetAPI
  class HttpClient
    def initialize(server)
      cert   = Puppet.settings[:hostcert]     #`puppet master --configprint hostcert`.strip
      cacert = Puppet.settings[:localcacert]  #`puppet master --configprint localcacert`.strip
      prvkey = Puppet.settings[:hostprivkey]  #`puppet master --configprint hostprivkey`.strip

      @prefix = server.path
      @client = Net::HTTP.new(server.host, server.port).tap do |client|
        client.use_ssl = true
        client.cert    = OpenSSL::X509::Certificate.new(File.read(cert))
        client.key     = OpenSSL::PKey::RSA.new(File.read(prvkey))
        client.ca_file = cacert
      end
    end

    def get(uri)
      headers = {'Accept' => 'application/json'}
      result = @client.get(File.join(@prefix, uri), headers)

      case result
      when Net::HTTPSuccess then
        JSON.parse(result.body)
      when Net::HTTPRedirection then
        @client.get(result["location"],headers)
      else
        raise "ERROR in request GET #{uri}: #{result.code} #{result.body}"
      end
    end

    def post(uri, body)
      headers = {'Accept' => 'application/json', 'Content-Type' => 'application/json'}
      result = @client.post(File.join(@prefix, uri), body, headers)

      case result
      when Net::HTTPSuccess then
        JSON.parse(result.body)
      when Net::HTTPRedirection then
        @client.get(result["location"],headers)
      else
        raise "ERROR in request POST #{uri}: #{result.code} #{result.body}"
      end
    end
  end

  def initialize
    confdir = Puppet.settings[:confdir]  # `puppet master --configprint confdir`.strip

    puppetdb = File.readlines(File.join(confdir, 'puppetdb.conf')).grep(/=/).map do|line|
      line.split('=').map(&:strip)
    end
    puppetdb = Hash[puppetdb]
    @puppetdb = HttpClient.new(URI.parse(puppetdb['server_urls'].split(',').first))

    classifier = YAML.load_file(File.join(confdir, 'classifier.yaml'))
    @classifier = HttpClient.new(URI.parse("https://#{classifier['server']}:#{classifier['port']}#{classifier['prefix']}"))

    @rbac = HttpClient.new(URI.parse("https://#{classifier['server']}:#{classifier['port']}/rbac-api"))
  end

  def facts(node)
    facts = @puppetdb.get("/pdb/query/v4/nodes/#{node}/facts")
    facts.inject { |h,fact| h.merge!(fact['name'] => fact['value']) }
  end

  def get_node_classification(node)
    facts = facts(node)
    trusted = facts.delete('trusted')
    body = {'fact'    => facts,
            'trusted' => trusted}.to_json

    @classifier.post("/v1/classified/nodes/#{node}", body)
  end

  def classify_group(group_id, class_name, params)
    body = {
      "classes" => {
        class_name => params
      }
    }.to_json
    @classifier.post("/v1/groups/#{group_id}", body)
  end

  def get_node_groups
    @classifier.get("/v1/groups")
  end

  def get_group_id(key, value)
    groups = get_node_groups
    matched_group = groups.select { |group|
      group[key] == value
    }
    matched_group[0]['id']
  end

  def create_rbac_user(username, email = "#{username}@puppetlabs.vm", password = "puppetlabs", display_name = username, role_ids)
    body = {
      "login" => username,
      "email" => email,
      "password" => password,
      "display_name" => display_name,
      "role_ids" => role_ids,
    }.to_json
    @rbac.post("/v1/users", body).body
  end
end

############ Now start execution ############

Puppet.initialize_settings(['--confdir', '/etc/puppetlabs/puppet'])

api = SimplePuppetAPI.new


## Get PE Master group id
master_group_id = api.get_group_id("name","PE Master")

## Create deployer user
puts 'Creating deployer user with password "puppetlabs"'
puts api.create_rbac_user(
  "deployer19",
  "deployer@puppet.vm",
  "puppetlabs",
  "Code Deployer",
  [4]
)

### Get deployment token
puts 'Requesting token for "deployer"'
puts %x(echo "puppetlabs" | puppet access login deployer --lifetime 1y)

### Add upstream repo
puts 'Configuring Code manager'
puts api.classify_group(
  master_group_id,
  "puppet_enterprise::profile::master",
  {
    "code_manager_auto_configure" => true,
    "r10k_remote" => "https://github.com/puppetlabs-education/classroom-control-pi"
  })

### Run puppet to enable code-manager
puts 'Running puppet for initial Code Manager configuration'
puts %x(puppet agent -t)

### Install classroom module with the PMT
puts 'Installng the classroom module to the global modulepath'
puts %x(puppet module install pltraining-classroom --modulepath=/etc/puppetlabs/code-staging/modules)
#
### Deploy code
puts 'Deploying production environment and global modules'
puts %x(puppet code deploy production --wait | jq .)
