class Bluetooth < Gtk::Box
    def initialize
        super(:vertical)

        append(top_bar)
        append(connected_devices)
    end

    private

    def top_bar
        center_box = Gtk::CenterBox.new

        box = Gtk::Box.new(:horizontal, 10)
        box.append(Button.new)
        box.append(Button.new)

        center_box.set_start_widget(Gtk::Label.new('Connected devices'))
        center_box.set_end_widget(box)

        center_box
    end

    def connected_devices
        Device.new('wow')
    end
end