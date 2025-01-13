module Widgets
  module Bluetooth
    class Devices < Gtk::Box
      def initialize(boxes, state, scan_results)
        super(:vertical, 10)

        @state = state
        @boxes = boxes
        @scan_results = scan_results
        @device_box = boxes[state]

        top_bar = Gtk::CenterBox.new
        top_bar.set_start_widget(Gtk::Label.new(@state.capitalize))
        top_bar.set_end_widget(scan_button) if @state == :more

        append(top_bar)
        append(@device_box)

        append_devices
      end

      def append_devices
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

      def scan_button
        Widgets::Generic::Button.new(icon: '', small: true) do
          @boxes[:more].children.each do |child|
            @boxes[:more].remove(child)
          end

          @scan_results.clear

          Services::BluetoothService.scan
        end
      end
    end
  end
end