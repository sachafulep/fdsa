module Widgets
  module Bar
    class Bluetooth < Widgets::Generic::Button
      def initialize
        super(icon: '') do
          window = $windows[:bluetooth]

          $windows[:network].set_visible(false)

          window.set_visible(!window.visible?)

          # window.child.start_connection_monitor if window.visible?
        end
      end
    end
  end
end
