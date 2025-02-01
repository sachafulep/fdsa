module Widgets
  module Network
    class Network < Gtk::CenterBox
      def initialize(name, type, connected, known)
        super()

        @known = known
        @status = Gtk::Label.new('')
        set_connected(connected)

        add_css_class('network__network')
        add_css_class('network__network--known') if known?

        set_hexpand(true)

        set_start_widget(Gtk::Label.new(name))
        set_end_widget(end_widget)
      end

      def set_connected(value)
        @connected = value

        @status.set_text(icon)
      end

      private

      def end_widget
        return button if known?

        @status
      end

      def button
        Widgets::Generic::Button.new(label: '', small: true)
      end

      def icon
        @connected ? '' : ''
      end

      def known?
        !@connected && @known
      end
    end
  end
end
