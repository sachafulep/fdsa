module Widgets
  module Bar
    class Bluetooth < Widgets::Generic::Button
      def initialize
        super(icon: '') do
          Services::WindowService.toggle_window(:bluetooth)

          # window.child.start_connection_monitor if window.visible?
        end
      end
    end
  end
end
