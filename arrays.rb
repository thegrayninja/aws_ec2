


class UpdateFirewall
  def initialize(**opts)
    puts 1
  end
array = [1, 2, 3]


array.each do |i|
  puts "
  {
    from_port: #{i},
    to_port: #{i},
    protocol: 'tcp',
  },"
  end
end


myhash = {22 => "tcp", 443 => "upd"}

#myhash = {'name' => 'Zed', 'age' => 39, 'height' => 6*12+2}

#puts myhash[22]


myhash.keys.each do |key|
  puts "#{key} - #{myhash[key]}"

end
