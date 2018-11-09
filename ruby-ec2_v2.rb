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
  end

end

class EC2
  def initialize(instance_id, connString)
    @instance_id = instance_id
    @ec2 = connString

    @statusCodes = Hash.new
    @statusCodes[0] = "pending"
    @statusCodes[16] = "running"
    @statusCodes[48] = "terminated"
    @statusCodes[64] = "stopping"
    @statusCodes[80] = "stopped"
  end


  def start
    id = @ec2.instance(@instance_id)
    if id.exists?
      id.start
      statusCode = @statusCodes[id.state.code]
      puts "#{@instance_id} - #{statusCode}"
    else
      puts "ERROR - cannot find #{instance_id}"
    end
  end


  def stop
    id = @ec2.instance(@instance_id)
    if id.exists?
      id.stop
      statusCode = @statusCodes[id.state.code]
      puts "#{@instance_id} - #{statusCode}"
    else
      puts "ERROR - cannot find #{instance_id}"
    end
  end

  def state
    #puts @instance_id
    id = @ec2.instance(@instance_id)
    if id.exists?
      statusCode = @statusCodes[id.state.code]
      puts "#{@instance_id} - #{statusCode}"
    else
      puts "ERROR - cannot find #{instance_id}"
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

  puts "\ntesting values:"
  instances.values.each do |instance|
    puts "suck it #{instance}"
  end
  puts "\ntesting collect:"
  puts instances.collect { |k, v| v }

  #puts instances
  test1 = instances[1]
  #puts "\n#{test1}"

  testinstance1 = EC2.new(test1, connString)
  puts testinstance1.state
  #puts testinstance1.stop
  #puts testinstance1.state

end


RunProgram()


#if this line shows up on debug list, something isn't closed out
