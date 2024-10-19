module Widgets
  module Bar
    class Main < Gtk::CenterBox
      def initialize
        super

        set_orientation(:vertical)

        add_css_class('bar')

        append_top
        append_bottom
      end

      private

      def append_top
        box = Gtk::Box.new(:vertical, 10)

        box.set_vexpand(true)

        box.append(
          Widgets::Generic::Button.new(icon: '') do
            window = $windows[:launcher]

            window.set_visible(!window.visible?) 
          end
        )

        set_start_widget(box)
      end

      def append_bottom
        box = Gtk::Box.new(:vertical, 10)

        box.append(Audio.new.revealer)
        box.append(Battery.new) if Services::DeviceService.laptop?
        box.append(Clock.new)
        box.append(Power.new.revealer)

        set_end_widget(box)
      end
    end
  end
end