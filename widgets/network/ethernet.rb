module Widgets
  module Network
    class Ethernet < Widgets::Network::Network
      def initialize
        super('Ethernet', :ethernet, connected, true)
      end

      def start_connection_monitor
        @thread = Thread.new do
          while $windows[:network].visible?
            set_connected(connected)

            sleep 2
          end
        end
      end

      private

      def connected
        data['state'] == 'routable (configured)'
      end

      def data
        parse_data
      end

      def parse_data
        result = `networkctl status 'enp*'`
        result = result.split(/\n/)
        
        result = result.select do |line|
          line.include?('Type') ||
          line.include?('State')
        end
        
        result = result.map do |line|
          key, value = line.split(":", 2).map(&:strip).map(&:downcase)

          [key, value]
        end.to_h
      end
    end
  end
end