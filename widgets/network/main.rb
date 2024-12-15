module Widgets
  module Network
    class Main < Gtk::Box
      def initialize
        super(:vertical)

        add_css_class('network')

        append(top_bar)
        append(networks)

        # when opened start running a loop in a thread which updates networking 
        # information automatically. when closed stop the thread.
      end

      private

      def top_bar
        box = Gtk::Box.new(:horizontal, 10)

        box.add_css_class('network__top-bar')

        box.append(Widgets::Network::Speedtest.new)

        box
      end

      def networks
        Widgets::Network::Ethernet.new
      end
    end
  end
end