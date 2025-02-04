module Widgets
  module Bluetooth
    class Main < Gtk::Box
      def initialize
        super(:vertical, 30)

        add_css_class('bluetooth')

        @top_bar = TopBar.new
        @connected_widget = Devices.new(:connected)
        @paired_widget = Devices.new(:paired)
        @more_widget = MoreDevices.new

        append(@top_bar)
        append(@connected_widget)
        append(@paired_widget)
        append(@more_widget)
      end

      def start_event_listener
        Services::BluetoothService.start_event_listener(callbacks)
      end

      def stop_event_listener
        Services::BluetoothService.stop_event_listener
      end

      private

      def callbacks
        {
          connected: method(:redraw),
          new: @more_widget.method(:append_scan_result),
          del: method(:redraw),
          paired: @more_widget.method(:clear_scan_results),
          power: @top_bar.method(:update_power_indicator)
        }
      end

      def redraw
        redraw_devices

        # sleep 5

        # volume = `~/Documents/scripts/audio/get_volume.sh`.gsub(/\n/, '')

        # $widgets[:volume].set_text(volume)
      end

      def redraw_devices
        @connected_widget.append_devices
        @paired_widget.append_devices

        queue_draw
      end
    end
  end
end
