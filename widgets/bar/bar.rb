class Bar < Gtk::Box
    def initialize
        super(:vertical, 10)

        add_css_class('bar')

        set_valign(:end)

        append_audio
        append_clock
        append_power_buttons
    end

    private

    def append_audio
        append(Audio.new.revealer)
    end

    def append_clock
        append(Clock.new)
    end

    def append_power_buttons
        append(Power.new.revealer)
    end
end