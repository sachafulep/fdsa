class DeviceService
    def self.laptop?
        `hostnamectl`.include?('Yoga Slim 7 Pro')
    end

    def self.desktop?
        !laptop?
    end

    def self.charging?
        return false if desktop?

        `cat /sys/class/power_supply/BAT0/status`.include?('Charging')
    end
end