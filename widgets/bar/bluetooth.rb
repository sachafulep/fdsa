module Widgets
  module Bar
    class Bluetooth < Widgets::Generic::Button
      def initialize
        super(label: '') do
          Services::WindowService.toggle_window(:bluetooth)

          window = Services::WindowService.window(:bluetooth)

          if window.visible?
            window.child.start_bluetooth_listener
          else
            window.child.stop_bluetooth_listener
          end
        end
      end
    end
  end
end
