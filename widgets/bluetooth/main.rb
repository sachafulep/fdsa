module Widgets
  module Bluetooth
    class Main < Gtk::Box
      def initialize
        super(:vertical, 10)

        add_css_class('bluetooth')

        append(connected_devices)
        append(paired_devices)
        append(more_devices)
      end

      private

      def connected_devices
        box = Gtk::Box.new(:vertical, 10)

        top_bar = Gtk::CenterBox.new
        top_bar.set_start_widget(Gtk::Label.new('Connected'))

        box.append(top_bar)

        Services::BluetoothService.connected_devices.each do |device|
          box.append(Widgets::Bluetooth::Device.new(device))
        end

        box
      end

      def paired_devices
        box = Gtk::Box.new(:vertical, 10)

        top_bar = Gtk::CenterBox.new
        top_bar.set_start_widget(Gtk::Label.new('Paired'))

        box.append(top_bar)

        devices = Services::BluetoothService.paired_devices
        connected_device_mac_addresses =
          Services::BluetoothService.connected_devices.map(&:mac_address)

        devices = devices.reject do |device|
            connected_device_mac_addresses.include?(device.mac_address)
        end

        devices.each do |device|
          box.append(Widgets::Bluetooth::Device.new(device))
        end

        box
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