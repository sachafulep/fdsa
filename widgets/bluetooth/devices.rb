module Widgets
  module Bluetooth
    class Devices < Gtk::Box
      def initialize(state)
        super(:vertical, 10)

        @state = state
        @device_box = Gtk::Box.new(:vertical, 10)
        @devices = devices(@state)

        @top_bar = Gtk::CenterBox.new
        @top_bar.set_start_widget(Gtk::Label.new(@state.capitalize))

        append(@top_bar)
        append(devices_widget)

        append_devices
      end

      def append_devices
        clear_children

        if @devices.length == 0
          label = Gtk::Label.new('...')
          label.set_vexpand(true)
          @device_box.append(label)
        else
          @devices.each {|device| @device_box.append(device) }
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

      private

      def devices_widget
        if @state == :more || @devices.length > 3
          scrolled_window = Gtk::ScrolledWindow.new
          scrolled_window.set_child(@device_box)
          scrolled_window.set_policy(:never, :automatic)
          scrolled_window.set_size_request(-1, 149)
        else
          @device_box
        end
      end
    end
  end
end
