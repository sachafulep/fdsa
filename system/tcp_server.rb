require 'socket'

class Tcp_server
    class << self
        def start
            server = TCPServer.new(12345)

            Thread.new do
                loop do
                    client = server.accept

                    @window_name = client.gets.chomp.to_sym

                    client.close; next if window.nil?
        
                    toggle_window
        
                    client.close
                end
            end
        end

        private

        def toggle_window
            window.set_visible(!window.visible?)

            window.child.entry.text = '' if @window_name == :launcher
        end

        def window
            return unless $windows.keys.include?(@window_name)

            @window ||= $windows[@window_name]
        end
    end
end