module Widgets
  module Bar
    class Power
      def revealer
        trigger = Widgets::Generic::Button.new(icon: '', command: 'sudo systemctl poweroff')
        child = revealer_buttons

        Revealer.new(trigger: trigger, child: child)
      end

      private

      def revealer_buttons
        box = Gtk::Box.new(:vertical, 10)

        suspend = Widgets::Generic::Button.new(icon: '', command: 'sudo systemctl suspend')
        reboot = Widgets::Generic::Button.new(icon: '', command: 'sudo systemctl reboot')

        reboot.add_css_class('first-revealer-item')

        box.append(suspend)
        box.append(reboot)
      end
    end
  end
end