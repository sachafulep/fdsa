module Widgets
  module Bluetooth
    class Devices < Gtk::Box
      def initialize(state)
        super(:vertical, 10)

        @state = state
        @device_box = Gtk::Box.new(:vertical, 10)

        @top_bar = Gtk::CenterBox.new
        @top_bar.set_start_widget(Gtk::Label.new(@state.capitalize))

        append(@top_bar)
        append(@device_box)

        append_devices
      end

      def append_devices
        clear_children

        devices = devices(@state)

        if devices.length == 0
          @device_box.append(Gtk::Label.new('...'))
        else
          devices.each {|device| @device_box.append(device) }
        end
      end

      def devices(state)
        return [] if @state == :more

        Services::BluetoothService.send("#{@state}_devices").map do |device|
          Widgets::Bluetooth::Device.new(device)
        end
      end

      def clear_children
        @device_box.children.each {|child| @device_box.remove(child) }
      end
    end
  end
end
