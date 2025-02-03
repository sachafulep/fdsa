module Widgets
  module Bar
    class Power < Widgets::Generic::Revealer
      def initialize
        super(trigger: trigger, child: child)
      end

      private

      def trigger
        button = Widgets::Generic::Button.new(label: '') do
          button.label = revealed? ? '' : ''
        end
      end

      def child
        box = Gtk::Box.new(:vertical, 10)

        suspend = Widgets::Generic::Button.new(label: '') { power_command(:suspend) }
        reboot = Widgets::Generic::Button.new(label: '') { power_command(:reboot) }
        power_off = Widgets::Generic::Button.new(label: '') { power_command(:poweroff) }

        power_off.add_css_class('first-revealer-item')

        box.append(suspend)
        box.append(reboot)
        box.append(power_off)
      end

      def power_command(state)
        `sudo systemctl #{state}`

        if state == :suspend
          `swaylock -e --indicator --clock --timestr "%H:%M" --datestr "%A, %b %d"`
        end

        hide
      end
    end
  end
end
