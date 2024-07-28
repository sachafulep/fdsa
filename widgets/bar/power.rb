class Power
    def revealer
        trigger = Button.new(icon: '', command: 'sudo systemctl poweroff')
        child = revealer_buttons

        Revealer.new(trigger: trigger, child: child)
    end

    private

    def revealer_buttons
        box = Gtk::Box.new(:vertical, 10)

        suspend = Button.new(icon: '', command: 'sudo systemctl suspend')
        reboot = Button.new(icon: '', command: 'sudo systemctl reboot')

        reboot.add_css_class('first-revealer-item')

        box.append(suspend)
        box.append(reboot)
    end
end