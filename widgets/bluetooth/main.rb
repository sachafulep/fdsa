module Widgets
  module Bluetooth
    class Main < Gtk::Box
      def initialize
        super(:vertical, 30)

        add_css_class('bluetooth')

        @connected_devices_box = Gtk::Box.new(:vertical, 10)
        @paired_devices_box = Gtk::Box.new(:vertical, 10)
        @more_devices_box = Gtk::Box.new(:vertical, 10)

        append(connected_devices)
        append(paired_devices)
        append(more_devices)

        Services::BluetoothService.listen_to_events(method(:redraw))
      end

      private

      def redraw
        @connected_devices_box.children.each do |child|
          @connected_devices_box.remove(child)
        end

        @paired_devices_box.children.each do |child|
          @paired_devices_box.remove(child)
        end

        append_connected_devices
        append_paired_devices

        queue_draw
      end

      def connected_devices
        box = Gtk::Box.new(:vertical, 10)

        top_bar = Gtk::CenterBox.new
        top_bar.set_start_widget(Gtk::Label.new('Connected'))

        box.append(top_bar)

        append_connected_devices

        box.append(@connected_devices_box)

        box
      end

      def append_connected_devices
        Services::BluetoothService.connected_devices.each do |device|
          @connected_devices_box.append(Widgets::Bluetooth::Device.new(device))
        end

        if Services::BluetoothService.connected_devices.length == 0
          @connected_devices_box.append(Gtk::Label.new('...'))
        end
      end

      def paired_devices
        box = Gtk::Box.new(:vertical, 10)

        top_bar = Gtk::CenterBox.new
        top_bar.set_start_widget(Gtk::Label.new('Paired'))

        box.append(top_bar)

        append_paired_devices

        box.append(@paired_devices_box)

        box
      end

      def append_paired_devices
        devices = Services::BluetoothService.paired_devices
        connected_device_mac_addresses =
          Services::BluetoothService.connected_devices.map(&:mac_address)

        devices = devices.reject do |device|
            connected_device_mac_addresses.include?(device.mac_address)
        end

        devices.each do |device|
          @paired_devices_box.append(Widgets::Bluetooth::Device.new(device))
        end
      end

      def more_devices
        box = Gtk::Box.new(:vertical, 10)

        top_bar = Gtk::CenterBox.new
        top_bar.set_start_widget(Gtk::Label.new('More'))
        top_bar.set_end_widget(
          Widgets::Generic::Button.new(icon: '', small: true)
        )

        box.append(top_bar)
        box.append(Gtk::Label.new('...'))
        
        box
      end
    end
  end
end