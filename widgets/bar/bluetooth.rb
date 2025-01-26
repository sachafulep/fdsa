module Widgets
  module Bar
    class Bluetooth < Widgets::Generic::Button
      def initialize
        super(icon: '') do
          Services::WindowService.toggle_window(:bluetooth)

          window = Services::WindowService.window(:bluetooth)

          if window.visible?
            window.child.start_event_listener
          else
            window.child.stop_event_listener
          end
        end
      end
    end
  end
end
