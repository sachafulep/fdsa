class Device < Gtk::Box
    def initialize(name, mac_address)
        super(:horizontal)

        @name = name
        @mac_address = mac_address

        append(content)
    end

    private

    def content
        center_box = Gtk::CenterBox.new

        center_box.set_hexpand(true)

        box = Gtk::Box.new(:horizontal, 10)
        
        box.set_halign(:end)
        
        box.append(Button.new(icon: '', command: "bluetoothctl connect #{@mac_address}"))
        box.append(Button.new(icon: '', command: "bluetoothctl remove #{@mac_address}"))

        center_box.set_start_widget(Gtk::Label.new(@name))
        center_box.set_end_widget(box)

        center_box
    end
end