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
    end
end