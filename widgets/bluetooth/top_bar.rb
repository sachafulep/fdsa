module Widgets
  module Bluetooth
    class TopBar < Gtk::CenterBox
      def initialize
        super

        set_start_widget(Gtk::Label.new('Bluetooth'))
        set_end_widget(power_switch)
      end

      def power_switch
        box = Gtk::Box.new(:horizontal, 10)

        powered = Services::BluetoothService.powered?

        power_indicator = Gtk::DrawingArea.new
        power_indicator.set_size_request(10, 10)

        power_indicator.set_draw_func do |widget, cr, width, height|
          r = 100.0 / 255
          g = 190.0 / 255
          b = 90.0 / 255

          cr.set_source_rgb(r, g, b)
          cr.arc(width / 2, height / 2, width / 2, 0, 2 * Math::PI)
          cr.fill
        end

        switch = Gtk::Switch.new

        switch.set_active(powered)

        switch.signal_connect('notify::active') do |widget, pspec|
          if widget.active?
            Services::BluetoothService.power_on
          else
            Services::BluetoothService.power_off
          end
        end

        box.append(power_indicator)
        box.append(switch)

        box
      end
    end
  end
end
