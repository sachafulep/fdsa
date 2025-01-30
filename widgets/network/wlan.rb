module Widgets
  module Network
    class Wlan < Gtk::Box
      def initialize
        super(:vertical, 10)

        # append(connected_network)
        # append(known_networks)
      end

      def start_connection_monitor
        # @thread = Thread.new do
        #   while $windows[:network].visible?
        #     set_connected(connected)

        #     sleep 2
        #   end
        # end
      end

      private

      def connected_network
        Widgets::Network::Network.new(
          data['connected network'],
          :wlan,
          connected,
          true
        )
      end

      def known_networks
        box = Gtk::Box.new(:vertical, 10)

        known_networks_names.each do |name|
          box.append(
            Widgets::Network::Network.new(
              name, :wlan, false, true
            )
          )
        end

        box
      end

      def known_networks_names
        result = `iwctl known-networks list`
        result = result.split(/\n/).last(2)
        
        result.map! do |line|
          line.gsub(/\e\[\d+m/, '')
              .strip
              .split(/\s{2,}/)[0]
        end

        result.reject! {|line| line == data['connected network'] }
      end

      def connected
        data['state'] == 'connected'
      end

      def data
        parse_data
      end

      def parse_data
        result = `iwctl station wlan0 show`
        result = result.split(/\n/)
        
        result = result.select do |line|
          line.include?('Connected network') ||
          line.include?('State')
        end.map(&:strip)
        
        result = result.map { |item| 
          key, value = item.split(/\s{2,}/)

          [key.strip.downcase, value.strip]
        }.to_h
      end
    end
  end
end