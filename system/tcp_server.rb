require 'socket'

module System
  class Tcp_server
    class << self
      def start
        server = TCPServer.new(12345)

        Thread.new do
          loop do
            client = server.accept

            params = client.gets.chomp.split

            @window_name = params.first.to_sym
            @state = params.last if params.length > 1

            @state = @state == "true" if @state

            client.close; next if window.nil?
      
            toggle_window
      
            client.close

            @state = nil
          end
        end
      end

      private

      def toggle_window
        @state = !window.visible? if @state.nil?

        window.set_visible(@state)

        hide_children

        window.child.entry.text = '' if @window_name == :launcher
      end

      def window
        return unless $windows.keys.include?(@window_name)

        $windows[@window_name]
      end

      def hide_children
        return if @state == true
        return if @window_name != :bar

        $windows[:network].set_visible(false) 
      end
    end
  end
end