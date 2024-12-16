module Services
  class BluetoothService
    Device = Struct.new(:name, :mac_address, :connected, :paired)

    class << self
      def connected_devices
        parse_devices(`bluetoothctl devices Connected`, true, true)
      end

      def paired_devices
        parse_devices(`bluetoothctl devices Paired`, false, true)
      end

      def disconnect_device(device)
        `bluetoothctl disconnect #{device.mac_address}`
      end

      private

      def parse_devices(result, connected, paired)
        result.split(/\n/).map do |device|
          parts = device.split

          Device.new(parts[2], parts[1], connected, paired)
        end
      end
    end
  end
end