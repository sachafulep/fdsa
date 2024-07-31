#!/usr/bin/env ruby

require 'socket'

SERVER_ADDRESS = 'localhost'
PORT = 12345

message = ARGV.join(' ')

if message.empty?
  puts "Usage: ruby client.rb 'Your message here'"
  exit 1
end

socket = nil

begin
  socket = TCPSocket.new(SERVER_ADDRESS, PORT)
rescue
  Thread.new { system('~/Documents/fdsa/fdsa.rb') }

  sleep(2000)

  socket = TCPSocket.new(SERVER_ADDRESS, PORT)
end

socket.puts(message)

socket.close

puts "Message sent!"
