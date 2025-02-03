module Widgets
  module Bluetooth
    class MoreDevices < Devices
      def initialize
        super(:more)

        @top_bar.set_end_widget(scan_button)

        @scan_results = {}
      end

      def scan_button
        button = Widgets::Generic::Button.new(label: '', small: true) do
          clear_children

          @scan_results.clear

          Services::BluetoothService.scan

          Thread.new do
            spinner = Gtk::Spinner.new
            spinner.start
            button.update_child(spinner)

            sleep(60)
            spinner.stop

            button.update_child(Gtk::Label.new(''))
          end
        end
      end

      def append_scan_result(device)
        return if @scan_results.key?(device.mac_address)

        @scan_results[device.mac_address] = device

        return if device.name.match?(/^[A-Za-z0-9]{2}(-[A-Za-z0-9]{2}){5}$/)

        @device_box.prepend(Widgets::Bluetooth::Device.new(device))

        queue_draw
      end

      def clear_scan_results
        clear_children

        queue_draw
      end
    end
  end
end
