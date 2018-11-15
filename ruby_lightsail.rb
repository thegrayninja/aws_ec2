require 'aws-sdk-lightsail'
# require 'json/add/struct'
# require 'ostruct'


class AWSSetup
  def initialize
    @client = Aws::Lightsail::Client.new(region: 'us-east-1')
    #@client = @clientString.get_instances
  end

  attr_reader :client

end

#client.operations
#resp = client.get_instances()

class LightsailStatus
  def getStatus#(client)
    #@client = client
    @client = Aws::Lightsail::Client.new(region: 'us-east-1')
    resp = @client.get_instances

    iName = resp.instances[0].name
    iPublicIP = resp.instances[0].public_ip_address
    iDateCreated = resp.instances[0].created_at
    iFirewall = resp.instances[0].networking.ports
    iState = resp.instances[0].state.name



      puts "#{iName}\n\t#{iPublicIP}\n\t#{iDateCreated}\n\t#{iState}"
    iFirewall.each do |i|
      puts "\n\tfrom: #{i.from_port}\n\tto: #{i.to_port}\n\tprotocol:\n\t#{i.protocol}\n\tfrom: #{i.access_from}\n"
    end
  end
end

class UpdateFirewall
  def updateFirewall#(client)
    #@client = client
    @client = Aws::Lightsail::Client.new(region: 'us-east-1')
    resp = @client.put_instance_public_ports({
      port_infos: [ # required
        {
          from_port: 80,
          to_port: 80,
          protocol: "tcp", # accepts tcp, all, udp
        },
        {
          from_port: 443,
          to_port: 443,
          protocol: "tcp", # accepts tcp, all, udp
        },
        # {
        #   from_port: 22,
        #   to_port: 22,
        #   protocol: "tcp", # accepts tcp, all, udp
        # },
      ],
      instance_name: "Ub-Virginia-1", # required
})
  end
end

lightsail = AWSSetup.new
lightsailStatus = LightsailStatus.new

lightsailStatus.getStatus#(lightsail)
lightsailFirewall = UpdateFirewall.new
lightsailFirewall.updateFirewall
lightsailStatus.getStatus


# resp = client.get_instances()
# iFirewall = resp.instances[0].networking.ports
#
# puts "#{iName}\n\t#{iPublicIP}\n\t#{iDateCreated}\n\t#{iState}"
# iFirewall.each do |i|
#   puts "\n\tfrom: #{i.from_port}\n\tto: #{i.to_port}\n\tprotocol:\n\t#{i.protocol}\n\tfrom: #{i.access_from}\n"
# end

# resp.values.each do |level|
#   puts "#{level}\n"
# end

# json = resp.to_json
#
# object = JSON.parse(json, object_class: OpenStruct)
# #puts newJson.ubuntu
#
#
# instanceInfo = object.v[0][0].v
# iName = instanceInfo[0]
# iID = instanceInfo[2]
# iDateCreated = instanceInfo[3]
# iPublicIP = instanceInfo[11]
#
# networkInfo = object.v[0][0].v[17]
#
# puts "Lightsail\n\t#{iName}\n\t#{iID}\n\t#{iDateCreated}\n\t#{iPublicIP}"
#
# puts "\n\n#{networkInfo}"
