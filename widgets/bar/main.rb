module Widgets
  module Bar
    class Main < Gtk::Box
      def initialize
        super(:vertical)

        add_css_class('bar')

        center_box = Gtk::CenterBox.new

        center_box.add_css_class('bar__widget')

        center_box.set_orientation(:vertical)

        center_box.set_start_widget(top)
        center_box.set_center_widget(middle)
        center_box.set_end_widget(bottom)

        append(center_box)
      end

      private

      def top
        box = Gtk::Box.new(:vertical, 10)

        box.set_vexpand(true)

        box.append(
          Widgets::Generic::Button.new(label: '') do
            Services::WindowService.toggle_window(:launcher)
          end
        )

        box
      end

      def middle
        box = Gtk::Box.new(:vertical, 10)

        box.append(Clock.new)
        box.append(Battery.new) if Services::DeviceService.laptop?

        box
      end

      def bottom
        box = Gtk::Box.new(:vertical, 10)

        box.append(Bluetooth.new)
        # box.append(Network.new) if Services::DeviceService.laptop?
        box.append(Audio.new)
        box.append(Power.new)

        box
      end
    end
  end
end
