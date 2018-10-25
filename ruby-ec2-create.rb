require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'base64'

#require 'json'


#puts JSON.parse(ec2.instances)
# To only get the first 10 instances:
# ec2.instances.limit(10).each do |i|


def Main()
  puts "thanks for turning me on"
  ec2 = SetupEC2Instance()
  encoded_script = EC2UserData()
  puts encoded_script
  CreateEC2Instance(ec2, encoded_script)
  puts "i hope you are satisfied"
end


def SetupEC2Instance()
  ec2 = Aws::EC2::Resource.new(region: 'us-west-1')
  return ec2
end


def EC2UserData()
  script = "Should import UserData for bootup from a txt file"
  puts "Should import UserData for bootup from a txt file"
  encoded_script = Base64.encode64(script)
  return encoded_script
end



def CreateEC2Instance(ec2, encoded_script)
  #set default values
  #account_id = "get this somewhere"
  min_count_default = 1
  max_count_default = 1
  key_name_default = "aws_key_pair"
  instance_type_default = "t2.micro"
  availability_zone_default = "us-west-1b"



  puts "Enter vital info for your instance:\n"
  print "  Account ID: "
  account_id = $stdin.gets.chomp
  print "  Image ID: "
  image_id = $stdin.gets.chomp
  print "  Min Count [1]: "
  min_count = $stdin.gets.chomp
  print "  Max Count [1]: "
  max_count = $stdin.gets.chomp
  print "  Key Name [aws_key_pair]: "
  key_name = $stdin.gets.chomp
  print "  Security Group IDs: "
  security_group_ids = $stdin.gets.chomp
  #print "  User Data: "
  #user_data = $stdin.gets.chomp
  print "  Instance Type [t2.micro]: "
  instance_type = $stdin.gets.chomp
  print "  Availability Zone [us-west-1b]: "
  availability_zone = $stdin.gets.chomp
  print "  Subnet ID: "
  subnet_id = $stdin.gets.chomp


  if min_count.empty?
    min_count = min_count_default
  else
    min_count = min_count.to_i
  end

  if max_count.empty?
    max_count = min_count_default
  else
    max_count = min_count.to_i
  end

  if key_name.empty?
    key_name = key_name_default
  end

  if instance_type.empty?
    instance_type = instance_type_default
  end

  if availability_zone.empty?
    availability_zone = availability_zone_default
  end

  puts min_count + 5





  instance = ec2.create_instances({
    image_id: image_id,
    min_count: min_count,
    max_count: max_count,
    key_name: key_name,
    security_group_ids: [security_group_ids],
    user_data: encoded_script,
    instance_type: instance_type,
    placement: {
      availability_zone: availability_zone
    },
    subnet_id: subnet_id,
    iam_instance_profile: {
      arn: 'arn:aws:iam::' + account_id + ':user/gamefrk220/aws-opsworks-ec2-role'
    }
  })

  # Wait for the instance to be created, running, and passed status checks
  ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance.first.id]})

  # Name the instance 'MyGroovyInstance' and give it the Group tag 'MyGroovyGroup'
  instance.create_tags({ tags: [{ key: 'Name', value: 'MyGroovyInstance' }, { key: 'Group', value: 'MyGroovyGroup' }]})

  puts instance.id
  puts instance.public_ip_address
end


Main()
