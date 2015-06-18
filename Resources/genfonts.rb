#!/usr/bin/ruby
path = ARGV.first
Dir.foreach(path) do |item|
  next if item == '.' or item == '..'
  puts "<string>"+item+"</string>"
end