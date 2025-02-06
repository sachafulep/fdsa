module Services
  class DeviceService
    class << self
      def laptop?
        `hostnamectl`.include?('Yoga Slim 7 Pro')
      end

      def desktop?
        !laptop?
      end

      def charging?
        return false if desktop?

        `cat /sys/class/power_supply/BAT0/status`.include?('Charging')
      end

      def bluetooth_device_name
        'WH-1000XM4'
      end

      def speaker_device_name
        if desktop?
          'DragonFly Red Analog Stereo'
        else
          'Family 17h/19h HD Audio Controller Analog Stereo'
        end
      end

      def headphone_device_name
        if desktop?
          'Schiit Modi 3 Analog Stereo'
        else
          'Family 17h/19h HD Audio Controller Analog Stereo'
        end
      end
    end
  end
end
