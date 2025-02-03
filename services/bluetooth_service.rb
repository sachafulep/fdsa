module Services
  class BluetoothService
    Device = Struct.new(:name, :mac_address, :connected, :paired)

    class << self
      def connected_devices
        parse_devices(`bluetoothctl devices Connected`, true, true)
      end

      def paired_devices
        devices = parse_devices(`bluetoothctl devices Paired`, false, true)

        connected_device_mac_addresses = connected_devices.map(&:mac_address)

        devices.reject do |device|
          connected_device_mac_addresses.include?(device.mac_address)
        end
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
        Thread.new do
          `bluetoothctl --timeout 60 scan on`
        end
      end

      def start_event_listener(callbacks)
        @listener_thread = Thread.new do
          IO.popen('bluetoothctl') do |bluetooth|
            bluetooth.each_line do |line|
              line = line.gsub(/\e\[[\d;]*m/, '').sub(/^.*?\[.*?\[/, "[").chomp

              ap line

              next if unwanted_line?(line)

              handle_device_status(line, callbacks)
            end
          end
        end
      end

      def stop_event_listener
        @listener_thread&.kill
      end

      private

      def unwanted_line?(line)
        [
          'Agent registered',
          'Waiting to connect to bluetoothd',
          'Pairable:',
          'Discovering:',
          'new_settings'
        ].any? do |substring|
          line.include?(substring)
        end
      end

      def handle_device_status(line, callbacks)
        if line =~ /Device\s([0-9A-F]{2}:){5}[0-9A-F]{2}\sConnected:\s(yes|no)/
          callbacks[:connected].call
        elsif line =~ /\[NEW\] Device ([0-9A-F:]+) (.+)/i
          callbacks[:new].call(Device.new($2, $1, false, false))
        elsif line =~ /\[DEL\]/
          callbacks[:del].call
        elsif line =~ /Paired:/
          callbacks[:paired].call
        elsif line =~ /Powered:\s(yes|no)/
          callbacks[:power].call(line.include?('yes') ? :on : :off)
        end
      end

      def parse_devices(result, connected, paired)
        result.split(/\n/).map do |device|
          parts = device.split

          Device.new(parts[2], parts[1], connected, paired)
        end
      end
    end
  end
end
