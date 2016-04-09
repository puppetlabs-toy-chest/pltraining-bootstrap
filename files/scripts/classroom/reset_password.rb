#! /usr/bin/ruby
# Reset root password and update login screen

print "Enter new root password: "
password = gets.chomp

%x(echo "root:#{password}"|chpasswd)

File.open('/var/local/password','w') do |f|
  f.puts password
end

%x(/etc/rc.local 2>/dev/null)
