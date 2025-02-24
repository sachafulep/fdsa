require 'socket'

module System
  class TcpServer
    class << self
      def start
        server = TCPServer.new(12345)

        Thread.new do
          loop { handle_client(server.accept) }
        end
      end

      private

      def handle_client(client)
        Thread.new(client) do |conn|
          process_request(conn)
        end
      end

      def process_request(conn)
        begin
          params = parse_request(conn.gets)

          return if params.empty?

          name = params.first
          state = params.last

          Services::WindowService.set_window(name.to_sym, state == 'true')
        ensure
          conn.close
        end
      end

      def parse_request(request)
        request&.chomp&.split || []
      end
    end
  end
end
