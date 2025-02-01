module Widgets
  module Bluetooth
    class Device < Gtk::Box
      def initialize(device)
        super(:horizontal, 10)

        @device = device
        @status = Gtk::Label.new('')

        add_css_class('bluetooth__device')
        add_css_class('bluetooth__device--connected') if device.connected

        label = Gtk::Label.new(device.name)
        label.set_max_width_chars(24)
        label.set_ellipsize(3)
        label.set_hexpand(true)
        label.set_halign(:start)

        append(label)
        append(end_widget)
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
