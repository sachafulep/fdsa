module Widgets
  module Bluetooth
    class Device < Gtk::CenterBox
      def initialize(device)
        super()

        @device = device
        @status = Gtk::Label.new('')

        add_css_class('bluetooth__device')
        add_css_class('bluetooth__device--connected') if device.connected

        set_hexpand(true)

        set_start_widget(Gtk::Label.new(device.name))
        set_end_widget(end_widget)
      end

      private

      def end_widget
        box = Gtk::Box.new(:horizontal, 10)

        box.append(action_button)
        box.append(remove_button) if @device.paired

        box
      end

      def action_button
        Widgets::Generic::Button.new(
          label: label,
          small: true,
          inverted_colors: @device.connected
        ) do
          if @device.paired
            if @device.connected
              Services::BluetoothService.disconnect_device(@device)
            else
              Services::BluetoothService.connect_device(@device)
            end
          else
            Services::BluetoothService.pair_device(@device)
          end
        end
      end

      def label
        return '' if @device.connected
        return '' if @device.paired

        ''
      end

      def remove_button
        Widgets::Generic::Button.new(
          label: '',
          small: true,
          inverted_colors: @device.connected
        ) do
          Services::BluetoothService.remove_device(@device)
        end
      end
    end
  end
end
