module Widgets
  module Bluetooth
    class Main < Gtk::Box
      def initialize
        super(:vertical)

        add_css_class('bluetooth')

        @top_bar = TopBar.new
        @connected_widget = Devices.new(:connected)
        @paired_widget = Devices.new(:paired)
        @more_widget = MoreDevices.new

        add_dismisser

        box = Gtk::Box.new(:vertical, 30)

        box.add_css_class('bluetooth__widget')

        box.append(@top_bar)
        box.append(@connected_widget)
        box.append(@paired_widget)
        box.append(@more_widget)

        append(box)
      end

      def start_bluetooth_listener
        redraw

        Services::Bluetooth::Listener.start(callbacks)
      end

      def stop_bluetooth_listener
        Services::Bluetooth::Listener.stop
      end

      private

      def add_dismisser
        gesture = Gtk::GestureClick.new
        
        gesture.signal_connect("pressed") do
          Services::WindowService.set_window(:bluetooth, false)
        end

        add_controller(gesture)
      end

      def callbacks
        {
          connected: method(:redraw),
          new: @more_widget.method(:append_scan_result),
          del: method(:redraw),
          paired: @more_widget.method(:clear_scan_results),
          powered: @top_bar.method(:update_power_indicator)
        }
      end

      def redraw
        redraw_devices

        Thread.new do
          sleep 5

          volume = `~/Documents/scripts/audio/get_volume.sh`.gsub(/\n/, '')

          $widgets[:volume].set_text(volume)
        end
      end

      def redraw_devices
        @connected_widget.append_devices
        @paired_widget.append_devices

        queue_draw
      end
    end
  end
end
