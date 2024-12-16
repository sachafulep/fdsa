module Widgets
  module Bluetooth
    class Device < Gtk::CenterBox
      def initialize(device)
        super()

        @device = device
        @status = Gtk::Label.new('')

        # set_connected(connected)

        add_css_class('bluetooth__device')
        add_css_class('bluetooth__device--paired') if device.paired && !device.connected

        set_hexpand(true)

        set_start_widget(Gtk::Label.new(device.name))
        set_end_widget(end_widget)
      end

      # def set_connected(value)
      #   @connected = value

      #   @status.set_text(icon)
      # end

      private

      def end_widget
        Widgets::Generic::Button.new(
          icon: icon,
          small: true,
          reverse: @device.connected
        ) do
          result = Services::BluetoothService.disconnect_device(@device)

          
        end
      end

      def icon
        return '' if @device.connected
        return '' if @device.paired

        ''
      end
    end
  end
end