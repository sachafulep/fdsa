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

      def connect_device(device)
        `bluetoothctl connect #{device.mac_address}`
      end

      def disconnect_device(device)
        `bluetoothctl disconnect #{device.mac_address}`
      end

      def listen_to_events(callback)
        Thread.new do
          IO.popen('bluetoothctl') do |bluetooth|
            bluetooth.each_line do |line|
              if line =~ /Device\s([0-9A-F]{2}:){5}[0-9A-F]{2}\sConnected:\s(yes|no)/
                callback.call
              end
            end
          end
        end
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