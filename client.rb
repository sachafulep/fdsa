require 'socket'

# Define the server address and port
SERVER_ADDRESS = 'localhost'
PORT = 12345

# Get the message from command line arguments
message = ARGV.join(' ')

# Check if a message was provided
if message.empty?
  puts "Usage: ruby client.rb 'Your message here'"
  exit 1
end

# Create a new TCP client and connect to the server
socket = TCPSocket.new(SERVER_ADDRESS, PORT)

# Send the message to the server
socket.puts(message)

# Close the socket
socket.close

puts "Message sent!"
