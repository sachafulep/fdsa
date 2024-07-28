class Revealer < Gtk::Box
    def initialize(trigger: [], child: nil)
        super(:vertical, 0)

        @child = child

        set_revealer_signals

        append(revealer)
        append(trigger)
    end

    private

    def revealer
        @revealer ||= begin
            instance = Gtk::Revealer.new

            instance.set_transition_type(:slide_up)
            instance.set_transition_duration(400)
            instance.set_child(@child)

            instance
        end
    end

    def revealer_buttons
        box = Gtk::Box.new(:vertical, 10)

        suspend = Button.new(icon: '', command: 'sudo systemctl suspend')
        reboot = Button.new(icon: '', command: 'sudo systemctl reboot')

        reboot.add_css_class('reboot-button')
        reboot.add_css_class('first-revealer-item')

        box.append(suspend)
        box.append(reboot)
    end

    def set_revealer_signals
        motion_controller = Gtk::EventControllerMotion.new

        motion_controller.signal_connect('enter') do |controller, event|
            revealer.set_reveal_child(true)
        end

        motion_controller.signal_connect('leave') do |controller, event|
            revealer.set_reveal_child(false)
        end

        add_controller(motion_controller)
    end
end