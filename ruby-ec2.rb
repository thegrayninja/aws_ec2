require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'json'


#puts JSON.parse(ec2.instances)
# To only get the first 10 instances:
# ec2.instances.limit(10).each do |i|


def Main()
  puts "thanks for turning me on"
  ec2 = SetupEC2Instance()
  GetInstanceInfo(ec2)
  data = "data_not_accurate"
  ChangeEC2State(data)
  puts "i hope you are satisfied"
end


def SetupEC2Instance()
  ec2 = Aws::EC2::Resource.new(region: 'us-west-1')
  return ec2
end



def GetInstanceInfo(ec2)
  counter = 1
  ec2.instances.each do |i|
    data = ""
    data += "#{counter.to_s} || "
    data += "#{i.id} || "
    data += "#{i.state.name} || "
    #puts "State_Code: #{i.state.code}"
    data += "#{i.key_name} || "
    data += "#{i.public_ip_address} ||"
    # data += i.tags.to_s
    # i.tags.to_json
    i.tags.each do |tags|
      data += "#{tags['key']}:#{tags['value']} "
    end

    puts data
    counter += 1

    #puts "Tag_Key: #{i.tags}"
    #puts "Tag_Value: #{i.tags.value}"

  end
end

def ChangeEC2State(instance_data)
  puts "Would you like to start up a machine? [y/n]"
  print "> "
  user_response_start = $stdin.gets.chomp
  puts user_response_start
  puts "ERROR: #{instance_data}"
end


Main()
