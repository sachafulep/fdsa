module Widgets
  module Network
    class Network < Gtk::CenterBox
      def initialize(name, type, connected)
        super()

        add_css_class('network__network')

        set_hexpand(true)

        @status = Gtk::Label.new('')
        @connected = set_connected(connected)

        set_start_widget(Gtk::Label.new('Ethernet'))
        set_end_widget(@status)
      end

      def set_connected(value)
        @connected = value

        @status.set_text(icon)
      end

      private

      def icon
        @connected ? '' : ''
      end
    end
  end
end