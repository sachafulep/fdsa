class Launcher < Gtk::Box
    def initialize(window)
        super(:horizontal)

        @window = window

        connect_signals

        append(Gtk::Label.new(''))
        append(entry)
    end

    def grab_focus
        entry.grab_focus
    end

    def entry
        @entry ||= begin
            instance = Gtk::Entry.new
            
            instance.set_can_focus(true)
            instance.set_focusable(true)
            instance.set_sensitive(true)
            instance.set_has_frame(false)

            instance
        end
    end

    private

    def connect_signals
        entry.signal_connect('activate') do
            command = entry.text.strip

            system(command)

            entry.text = ''

            @window.set_visible(false)
        end
    end
end