module Widgets
  module Network
    class Main < Gtk::Box
      def initialize
        super(:vertical)

        add_css_class('network')

        append(top_bar)
        append(networks)
      end

      def start_connection_monitor
        networks.start_connection_monitor
      end

      private

      def top_bar
        box = Gtk::Box.new(:horizontal, 10)

        box.add_css_class('network__top-bar')

        box.append(Widgets::Network::Speedtest.new)

        box
      end

      def networks
        Services::DeviceService.laptop? ? wlan : ethernet
      end

      def wlan
        @wlan ||= Widgets::Network::Wlan.new
      end

      def ethernet
        @ethernet ||= Widgets::Network::Ethernet.new
      end
    end
  end
end