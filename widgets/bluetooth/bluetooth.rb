class Bluetooth < Gtk::Box
    def initialize
        super(:vertical)

        @new_devices = {}
        @new_devices_window = new_devices

        append(top_bar)
        append(connected_devices)
        append(middle_bar)
        append(@new_devices_window)
    end

    private

    def top_bar
        center_box = Gtk::CenterBox.new

        center_box.add_css_class('bluetooth-top-bar')

        center_box.set_start_widget(Gtk::Label.new('Connected devices'))

        center_box
    end

    def connected_devices
        output = `bluetoothctl devices Connected`
        devices = output.split("\n")

        device_names = devices.map {|device| device.split[2] }

        box = Gtk::Box.new(:vertical, 5)

        device_names.each do |device_name|
            box.append(Device.new(device_name))
        end

        height =
            case device_names.size
            when 0, 1 then 40
            when 2 then 80
            else 120
            end

        window = Gtk::ScrolledWindow.new
        window.vexpand = true
        window.hexpand = true
        window.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
        window.add_css_class('bluetooth-devices')
        window.set_min_content_height(height)
        window.set_child(box)

        window
    end

    def middle_bar
        center_box = Gtk::CenterBox.new

        center_box.add_css_class('bluetooth-middle-bar')

        center_box.set_start_widget(Gtk::Label.new('Connect a device'))

        scan_button = Button.new(icon: '') do
            @new_devices_window.set_child(scanning)

            output = `bluetoothctl --timeout 5 scan on`

            sanitized_output = output.lines.map {|line| line.gsub(/\033\[[0-9;]*m/, '') }

            new_lines = sanitized_output.select {|line| line.start_with?('[NEW]') }

            new_lines.each do |line|
                mac_address = line.split[2]
                name = line.split(mac_address)[1]

                @new_devices[mac_address] = name
            end

            puts @new_devices
        end

        center_box.set_end_widget(scan_button)

        center_box
    end

    def new_devices
        window = Gtk::ScrolledWindow.new
        window.vexpand = true
        window.hexpand = true
        window.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
        window.set_min_content_height(130)
        window.add_css_class('bluetooth-devices')
        
        window.set_child(scan_to_find)

        window
    end

    def scan_to_find
        @scan_to_find ||= begin
            box = Gtk::Box.new(:vertical)

            box.set_valign(:center)

            box.append(Gtk::Label.new('scan to find devices'))

            box
        end
    end
    
    def scanning
        @scan_to_find ||= begin
            box = Gtk::Box.new(:vertical)

            box.set_valign(:center)

            box.append(Gtk::Label.new('scanning'))

            box
        end
    end
end