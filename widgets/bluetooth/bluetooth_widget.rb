class BluetoothWidget < Gtk::Box
    def initialize
        super(:vertical)

        append(top_bar)
        append(ConnectedDevices.new)
        append(middle_bar)
        append(new_devices)
    end

    private

    def top_bar
        box = Gtk::Box.new(:horizontal)

        box.add_css_class('bluetooth-top-bar')

        box.append(Gtk::Label.new('Connected devices'))

        box
    end

    def middle_bar
        center_box = Gtk::CenterBox.new

        center_box.add_css_class('bluetooth-middle-bar')

        center_box.set_start_widget(Gtk::Label.new('Connect a new device'))

        box = Gtk::Box.new(:horizontal, 10)

        scan_button = Button.new(icon: '') do
            scan_to_find.children.each {|child| scan_to_find.remove(child) }
            scan_to_find.set_valign(:start)

            Thread.new do
                BluetoothService.toggle_scan(scan_to_find)
            end
        end

        stop_button = Button.new(icon: 'X') do
            BluetoothService.stop_scan
        end

        box.append(scan_button)
        box.append(stop_button)

        center_box.set_end_widget(box)

        center_box
    end

    def new_devices
        @new_devices ||= begin
            window = Gtk::ScrolledWindow.new
            window.vexpand = true
            window.hexpand = true
            window.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
            window.set_min_content_height(130)
            window.add_css_class('bluetooth-devices')
            
            window.set_child(scan_to_find)

            window
        end
    end

    def scan_to_find
        @scan_to_find ||= begin
            box = Gtk::Box.new(:vertical, 5)

            box.set_valign(:center)

            box.append(Gtk::Label.new('scan to find devices'))

            box
        end
    end
end