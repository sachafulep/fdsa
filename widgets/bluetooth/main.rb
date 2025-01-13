module Widgets
  module Bluetooth
    class Main < Gtk::Box
      def initialize
        super(:vertical, 30)

        add_css_class('bluetooth')

        @scan_results = {}
        @boxes = {
          connected: Gtk::Box.new(:vertical, 10),
          paired: Gtk::Box.new(:vertical, 10),
          more: Gtk::Box.new(:vertical, 10),
        }

        append(TopBar.new)
        append(Devices.new(@boxes, :connected, @scan_results))
        append(Devices.new(@boxes, :paired, @scan_results))
        append(Devices.new(@boxes, :more, @scan_results))

        Services::BluetoothService.listen_to_events(callbacks)
      end

      private

      def callbacks
        {
          connected: method(:redraw),
          new: method(:append_scan_result)
        }
      end

      def redraw
        ['connected', 'paired'].each do |state|
          @boxes[state].each do |box|
            box.children.each {|child| box.remove(child) }
          end

         append_devices(state)
        end

        queue_draw
      end

      def append_scan_result(device)
        return if @scan_results.key?(device.mac_address)

        @scan_results[device.mac_address] = device

        @boxes[:more].append(Widgets::Bluetooth::Device.new(device))

        queue_draw
      end
    end
  end
end