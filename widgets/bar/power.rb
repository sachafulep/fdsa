module Widgets
  module Bar
    class Power < Widgets::Generic::Revealer
      def initialize
        super(trigger: trigger, child: child)
      end

      private

      def trigger
        Widgets::Generic::Button.new(icon: '') { `sudo systemctl poweroff` }
      end

      def child
        box = Gtk::Box.new(:vertical, 10)

        suspend = Widgets::Generic::Button.new(icon: '') { `sudo systemctl suspend` }
        reboot = Widgets::Generic::Button.new(icon: '') { `sudo systemctl reboot` }

        reboot.add_css_class('first-revealer-item')

        box.append(suspend)
        box.append(reboot)
      end
    end
  end
end
