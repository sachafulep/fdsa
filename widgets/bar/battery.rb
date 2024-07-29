class Battery < Gtk::Box
    def initialize
        super(:vertical, 0)

        add_css_class('item')

        append(icon)
        append(Gtk::Label.new(percentage))

        GLib::Timeout.add(5000000) do
            update_percentage
            
            true
        end
    end

    private

    def update_percentage
        children[2].set_text(percentage)
    end

    def icon
        icon = DeviceService.charging? ? '' : ''
        
        label = Gtk::Label.new(icon)

        label.add_css_class('item__icon')

        label
    end

    def percentage
        `cat /sys/class/power_supply/BAT0/capacity`.gsub(/\n/, '')
    end
end