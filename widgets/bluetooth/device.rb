class Device < Gtk::Box
    def initialize(name)
        super(:horizontal)

        @name = name

        append(content)
    end

    private

    def content
        center_box = Gtk::CenterBox.new

        box = Gtk::Box.new(:horizontal, 10)
        box.append(Button.new)
        box.append(Button.new)

        center_box.set_start_widget(Gtk::Label.new(@name))
        center_box.set_end_widget(box)

        center_box
    end
end