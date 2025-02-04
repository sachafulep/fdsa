module Services
  module Bluetooth
    class Devices
      Device = Struct.new(:name, :mac_address, :connected, :paired)

      class << self
        def connected
          parse(`bluetoothctl devices Connected`, true, true)
        end

        def paired
          devices = parse(`bluetoothctl devices Paired`, false, true)

          connected_addresses = connected.map(&:mac_address)

          devices.reject {|device| connected_addresses.include?(device.mac_address) }
        end

        private

        def parse(result, connected, paired)
          result.split(/\n/).map do |device|
            parts = device.split

            Device.new(parts[2], parts[1], connected, paired)
          end
        end
      end
    end
  end
end
