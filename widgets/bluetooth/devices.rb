module Widgets
  module Bluetooth
    class Devices < Gtk::Box
      def initialize(state)
        super(:vertical, 10)

        @state = state
        @devices = devices(@state)

        @top_bar = Gtk::CenterBox.new
        @top_bar.set_start_widget(Gtk::Label.new(@state.capitalize))

        @device_box = Gtk::Box.new(:vertical, 10)
        @scrolled_window = scrolled_window

        append(@top_bar)
        append(@scrolled_window)

        resize_scrolled_window

        append_devices
      end

      def append_devices
        clear_children

        @devices = devices(@state)

        if @devices.length == 0
          label = Gtk::Label.new('...')
          label.set_vexpand(true)
          @device_box.append(label)
        else
          @devices.each {|device| @device_box.append(device) }
        end

        resize_scrolled_window
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

      def scrolled_window
        scrolled_window = Gtk::ScrolledWindow.new
        scrolled_window.set_child(@device_box)
        scrolled_window.set_policy(:never, :automatic)
        scrolled_window
      end

      def resize_scrolled_window
        height =
          if @devices.length > 3 || @state == :more
            150
          else
            50 * @devices.length
          end

        @scrolled_window.set_size_request(-1, height)

        @scrolled_window.queue_draw
      end
    end
  end
end
