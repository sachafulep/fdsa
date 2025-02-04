module Widgets
  module Bluetooth
    class TopBar < Gtk::CenterBox
      COLORS = {
        green: [100.0 / 255, 190.0 / 255, 90.0 / 255],
        red: [230.0 / 255, 90.0 / 255, 90.0 / 255]
      }

      def initialize
        super

        @power_indicator = Gtk::DrawingArea.new
        @powered = Services::BluetoothService.powered?
        @color = @powered ? COLORS[:green] : COLORS[:red]

        label = Gtk::Label.new('Bluetooth')
        label.add_css_class('bluetooth__header')
        set_start_widget(label)
        set_end_widget(power_switch)
      end

      def update_power_indicator(state)
        @color = state == :on ? COLORS[:green] : COLORS[:red]

        @power_indicator.queue_draw
      end

      private

      def power_switch
        box = Gtk::Box.new(:horizontal, 10)

        draw_power_indicator

        box.append(@power_indicator)
        box.append(switch)

        box
      end

      def draw_power_indicator
        @power_indicator.set_size_request(10, 10)

        @power_indicator.set_draw_func do |widget, cr, width, height|
          cr.set_source_rgb(@color)
          cr.arc(width / 2, height / 2, width / 2, 0, 2 * Math::PI)
          cr.fill
        end
      end

      def switch
        switch = Gtk::Switch.new

        switch.set_active(@powered)

        switch.signal_connect('notify::active') do |widget, pspec|
          if widget.active?
            Services::BluetoothService.power_on
          else
            Services::BluetoothService.power_off
          end
        end

        switch
      end
    end
  end
end
