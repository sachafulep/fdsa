require 'socket'

module System
  class Tcp_server
    class << self
      def start
        server = TCPServer.new(12345)

        Thread.new do
          loop do
            client = server.accept

            Thread.new(client) do |conn|
              begin
                params = conn.gets&.chomp&.split

                if params && !params.empty?
                  Services::WindowService.toggle_window(params.first.to_sym)
                end
              ensure
                conn.close
              end
            end
          end
        end
      end
    end
  end
end
