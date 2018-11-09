require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'json'


#puts JSON.parse(ec2.instances)
# To only get the first 10 instances:
# ec2.instances.limit(10).each do |i|

class AWSSetup
  def initialize
    @awsRegion = 'us-east-1'
    @ec2connstring = Aws::EC2::Resource.new(region: @awsRegion)
  end

  attr_reader :awsRegion
  attr_reader :ec2connstring

  def set(awsRegion)
    @awsRegion = awsRegion
    @ec2connstring = Aws::EC2::Resource.new(region: @awsRegion)
  end

end


class GetInstanceData
  def initialize(connString)
    #@instancetype = "ec2"
    @awsRegion = awsRegion
    @ec2 = connString
  end

  attr_reader :awsRegion
  attr_reader :instance_data

  def info
    @counter = 1
    @instance_data = Hash.new

    @ec2.instances.each do |i|
      @data = ""
      @data += "#{@counter.to_s} || "
      @data += "#{i.id} || "
      @data += "#{i.state.name} || "

      @data += "#{i.key_name} || "
      @data += "#{i.public_ip_address} ||"

      i.tags.each do |tags|
        @data += "#{tags['key']}:#{tags['value']} "
      end

      @instance_data[@counter] = i.id
      puts @data

      @counter += 1
    end
    #puts instance_data
    #puts ec2InstanceList
  end

end

class EC2
  def initialize(instance_id, connString)
    @instance_id = instance_id
    @ec2 = connString
  end

  # attr_reader :instance_id
  # attr_reader :ec2connstring

  def start
    #@instance_id = instance_id
    #@ec2 = ec2
    id = @ec2.instance(@instance_id)
    if id.exists?
      case id.state.code
      when 0  # pending
        puts "#{@instance_id} is pending, so it will be running in a bit"
      when 16  # started
        puts "#{@instance_id} has already started"
      when 48  # terminated
        puts "#{@instance_id} is terminated, so you cannot start it"
      else
        id.start
      end
    end
  end

  def stop
    #@instance_id = instance_id
    #@ec2 = ec2
    id = @ec2.instance(@instance_id)
    if id.exists?
      case id.state.code
      when 48  # terminated
        puts "#{@instance_id} is terminated, so you cannot stop it"
      when 64  # stopping
        puts "#{@instance_id} is stopping, so it will be stopped in a bit"
      when 80  # stopped
        puts "#{@instance_id} is already stopped"
      else
        id.stop
      end
    end
  end

  def state
    #@instance_id = instance_id
    #@ec2 = ec2
    puts @instance_id
    id = @ec2.instance(@instance_id)
    if id.exists?
      case id.state
      when 0  # pending
        puts "#{@instance_id} is pending, so it will be running in a bit"
      when 16  # started
        puts "#{@instance_id} has already started"
      when 48  # terminated
        puts "#{@instance_id} is terminated, so you cannot stop it"
      when 64  # stopping
        puts "#{@instance_id} is stopping, so it will be stopped in a bit"
      when 80  # stopped
        puts "#{@instance_id} is stopped"
      else
        puts id.state
      end
    end
  end

end


def RunProgram()
  uswest1 = AWSSetup.new
  uswest1.set('us-west-1')
  connString = uswest1.ec2connstring

  myEc2Instances = GetInstanceData.new(connString)
  myEc2Instances.info
  instances = myEc2Instances.instance_data
  puts instances
  test1 = instances[1]
  puts "\n#{test1}"

  testinstance1 = EC2.new(test1, connString)
  puts testinstance1.state
  puts testinstance1.stop
  puts testinstance1.state
  # puts "\nWould you like to power ON an instance? [y/n]"
  # print "> "
  # response = $stdin.gets.chomp()
  # puts response
  # if response == "y"
  #   puts "Please enter number associated with instance:"
  #   print("> ")
  #   response = $stdin.gets.chomp()
  #   instanceID = instances[response.to_i]
  #   instance_test1 = EC2.new(instances[instanceID], uswest1.awsRegion)
  #   puts instance_test1.state
  #   #instanceState = myEc2Instances.state
  #   #puts instanceState(instances[response.to_i], )
  # else
  #   puts "ok, things will stay the same"
  # end
  # puts "\nWould you like to power OFF an instance? [y/n]"
  # print "> "
  # response = $stdin.gets.chomp()
  # puts response

  #myEc2Instances.GetInstanceInfo

end


RunProgram()



# def Main()
#   puts "thanks for turning me on"
#   ec2 = SetupEC2Instance()
#   data = GetInstanceInfo(ec2)
#   #data = "data_not_accurate"
#   ChangeEC2State(data, ec2)
#   puts "i hope you are satisfied"
# end
#
#
# def SetupEC2Instance()
#   ec2 = Aws::EC2::Resource.new(region: 'us-west-1')
#   return ec2
# end



# def GetInstanceInfo(ec2)
#   counter = 1
#   instance_data = Hash.new
#   ec2.instances.each do |i|
#     data = ""
#     data += "#{counter.to_s} || "
#     data += "#{i.id} || "
#     data += "#{i.state.name} || "
#
#     data += "#{i.key_name} || "
#     data += "#{i.public_ip_address} ||"
#
#     i.tags.each do |tags|
#       data += "#{tags['key']}:#{tags['value']} "
#     end
#
#     instance_data[counter] = i.id
#     puts data
#     counter += 1
#   end
#
#   return instance_data
# end


# def ChangeEC2State(instance_data, ec2)
#   puts "Would you like to start up a machine? [y/n]"
#   print "> "
#   user_response_start = $stdin.gets.chomp
#
#   if user_response_start == "y"
#     puts "Please enter the row number you'd like to spin up [ie, 1]"
#     print "> "
#     user_response_id = $stdin.gets.chomp.to_i
#     if user_response_id == 0
#       puts "You fool, that's a character...not a number! Try again."
#       ChangeEC2State(instance_data)
#     else
#       instance_id = instance_data[user_response_id]
#       puts "Starting Instance: #{instance_id}"
#       StartEC2Instance(instance_id, ec2)
#       puts "Would you like to start/stop another instance? [y/n]"
#       print "> "
#       user_response_change = $stdin.gets.chomp
#       if user_response_change == "y"
#         ChangeEC2State(instance_data, ec2)
#       else
#         return 0
#       end
#     end
#   end
#
#   puts "Would you like to STOP a machine? [y/n]"
#   print "> "
#   user_response_stop = $stdin.gets.chomp
#
#   if user_response_stop == "y"
#     puts "Please enter the row number you'd like to STOP [ie, 1]"
#     print "> "
#     user_response_id = $stdin.gets.chomp.to_i
#     if user_response_id == 0
#       puts "You fool, that's a character...not a number! Try again."
#       ChangeEC2State(instance_data)
#     else
#       instance_id = instance_data[user_response_id]
#       puts "Stopping Instance: #{instance_id}"
#       StopEC2Instance(instance_id, ec2)
#       puts "Would you like to start/stop another instance? [y/n]"
#       print "> "
#       user_response_change = $stdin.gets.chomp
#       if user_response_change == "y"
#         ChangeEC2State(instance_data, ec2)
#       else
#         return 0
#       end
#     end
#   end
# end
#
#
# def StartEC2Instance(instance_id, ec2)
#   i = ec2.instance(instance_id)
#   if i.exists?
#     case i.state.code
#     when 0  # pending
#       puts "#{instance_id} is pending, so it will be running in a bit"
#     when 16  # started
#       puts "#{instance_id} is already started"
#     when 48  # terminated
#       puts "#{instance_id} is terminated, so you cannot start it"
#     else
#       i.start
#     end
#   end
# end
#
#
# def StopEC2Instance(instance_id, ec2)
#   i = ec2.instance(instance_id)
#   if i.exists?
#     case i.state.code
#     when 48  # terminated
#       puts "#{instance_id} is terminated, so you cannot stop it"
#     when 64  # stopping
#       puts "#{instance_id} is stopping, so it will be stopped in a bit"
#     when 80  # stopped
#       puts "#{instance_id} is already stopped"
#     else
#       i.stop
#     end
#   end
# end


# Main()
