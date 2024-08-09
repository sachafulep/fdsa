class Bluetooth < Gtk::Box
    def initialize
        super(:vertical)

        append(top_bar)
        append(connected_devices)
        append(middle_bar)
        append(new_devices)
    end

    private

    def top_bar
        center_box = Gtk::CenterBox.new

        box = Gtk::Box.new(:horizontal, 10)
        box.append(Button.new(icon: ''))

        center_box.set_start_widget(Gtk::Label.new('Connected devices'))
        center_box.set_end_widget(box)

        center_box
    end

    def connected_devices
        window = Gtk::ScrolledWindow.new
        window.vexpand = true
        window.hexpand = true
        window.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
        window.set_min_content_height(130)
        window.add_css_class('bluetooth-devices')
        
        box = Gtk::Box.new(:vertical, 5)

        output = `bluetoothctl devices`
        devices = output.split("\n")

        device_names = devices.map {|device| device.split[2] }

        device_names.each do |device_name|
            box.append(Device.new(device_name))
        end

        window.set_child(box)

        window
    end

    def middle_bar
        box = Gtk::Box.new(:horizontal)

        box.add_css_class('bluetooth-middle-bar')

        box.append(Gtk::Label.new('Connect a device'))

        box
    end

    def new_devices
        window = Gtk::ScrolledWindow.new
        window.vexpand = true
        window.hexpand = true
        window.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
        window.set_min_content_height(130)
        window.add_css_class('bluetooth-devices')
        
        box = Gtk::Box.new(:vertical)

        box.set_valign(:center)

        box.append(Gtk::Label.new('scan to find devices'))

        window.set_child(box)

        window
    end
end