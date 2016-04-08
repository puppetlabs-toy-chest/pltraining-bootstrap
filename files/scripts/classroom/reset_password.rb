#! /usr/bin/ruby
# Reset root password and update login screen

unless ARGV.empty?
  puts "#{$0} is a wrapper to native system password management tools to"
  puts "ensure that the login information is displayed on the Console correctly."
  puts
  puts "The native tools have been renamed to passwd.orig and chpasswd.orig."
  puts
  exit 1
end

print "Enter new root password: "
password = gets.chomp

%x(echo "root:#{password}"|chpasswd.orig)

File.open('/var/local/password','w') do |f|
  f.puts password
end

# now update /etc/issue
%x(/etc/rc.local 2>/dev/null)
