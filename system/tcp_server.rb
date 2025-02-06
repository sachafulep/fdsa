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

          Services::WindowService.toggle_window(params.first.to_sym) if params.any?
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
