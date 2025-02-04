module Services
  module Bluetooth
    class LogLine
      UNWANTED_SUBSTRINGS = [
        'Agent registered', 'Waiting to connect to bluetoothd',
        'Pairable:', 'Discovering:', 'new_settings', 'Endpoint',
        'Transport', 'ServicesResolved', 'is nil', 'RSSI', 'TxPower',
        'ManufacturerData'
      ]

      CALLBACK_PATTERNS = {
        /Connected/ => :connected,
        /Paired/ => :paired,
        /Powered/ => :powered,
        /\[DEL\]/ => :del,
        /\[NEW\]/ => :new
      }

      def initialize(input)
        @line = sanitize(input)
      end

      def unwanted?
        UNWANTED_SUBSTRINGS.any? {|substring| @line.include?(substring) }
      end

      def callback_type
        CALLBACK_PATTERNS.each { |pattern, type| return type if @line =~ pattern }
      end

      def positive?
        @line.include?('yes')
      end

      def to_device
        Services::Bluetooth::Devices::Device.new(name, mac_address, false, false)
      end

      private

      def sanitize(input)
        input.gsub(/\e\[[\d;]*m/, '').sub(/^.*?\[.*?\[/, "[").chomp
      end

      def name
        @line.split[3..-1].join(" ")
      end

      def mac_address
        @line.split[2]
      end
    end
  end
end
