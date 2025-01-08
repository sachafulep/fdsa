module Widgets
  module Bluetooth
    class Device < Gtk::CenterBox
      def initialize(device)
        super()

        @device = device
        @status = Gtk::Label.new('')

        add_css_class('bluetooth__device')
        add_css_class('bluetooth__device--paired') if device.paired && !device.connected

        set_hexpand(true)

        set_start_widget(Gtk::Label.new(device.name))
        set_end_widget(end_widget)
      end

      private

      def end_widget
        Widgets::Generic::Button.new(
          icon: icon,
          small: true,
          inverse_colors: @device.connected
        ) do
          if @device.connected
            Services::BluetoothService.disconnect_device(@device)
          else
            Services::BluetoothService.connect_device(@device)
          end
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