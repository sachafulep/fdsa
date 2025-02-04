module Services
  class BluetoothService
    class << self
      def connected_devices
        Bluetooth::Devices.connected
      end

      def paired_devices
        Bluetooth::Devices.paired
      end

      def connect_device(device)
        `bluetoothctl connect #{device.mac_address}`
      end

      def disconnect_device(device)
        `bluetoothctl disconnect #{device.mac_address}`
      end

      def pair_device(device)
        `bluetoothctl pair #{device.mac_address}`
      end

      def remove_device(device)
        `bluetoothctl remove #{device.mac_address}`
      end

      def powered?
        `bluetoothctl show`.match(/Powered:\s*(\w+)/)[1] == 'yes'
      end

      def power_off
        `bluetoothctl power off`
      end

      def power_on
        `bluetoothctl power on`
      end

      def scan
        Thread.new { `bluetoothctl --timeout 60 scan on` }
      end
    end
  end
end
