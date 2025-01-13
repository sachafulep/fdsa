module Widgets
  module Bluetooth
    class MoreDevices < Devices
      def initialize
        super(:more)

        @top_bar.set_end_widget(scan_button)

        @scan_results = {}
      end

      def scan_button
        Widgets::Generic::Button.new(icon: '', small: true) do
          clear_children

          @scan_results.clear

          Services::BluetoothService.scan
        end
      end

      def append_scan_result(device)
        return if @scan_results.key?(device.mac_address)

        @scan_results[device.mac_address] = device

        @device_box.append(Widgets::Bluetooth::Device.new(device))

        queue_draw
      end

      def clear_scan_results
        clear_children

        queue_draw
      end
    end
  end
end