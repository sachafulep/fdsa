class Button < Gtk::Box
    def initialize(orientation: :vertical, spacing: 0, icon: '?', command: '')
        super(orientation, spacing)

        @icon = icon
        @command = command

        add_css_class('item')

        set_vexpand(false)
        set_size_request(40, 40)
        set_cursor(Gdk::Cursor.new('pointer'))

        set_icon
        set_click_action
    end

    private

    def set_icon
        label = Gtk::Label.new(@icon)

        label.set_vexpand(true)

        append(label)
    end

    def set_click_action
        click_gesture = Gtk::GestureClick.new

        click_gesture.signal_connect('pressed') do |gesture, n_press, x, y|
            system(@command)
        end
    
        add_controller(click_gesture)
    end
end