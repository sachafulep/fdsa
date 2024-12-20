module Widgets
  module Bar
    class Network < Widgets::Generic::Button
      def initialize
        super(icon: '') do
          window = $windows[:network]

          $windows[:bluetooth].set_visible(false)

          window.set_visible(!window.visible?)
          
          window.child.start_connection_monitor if window.visible?
        end
      end
    end
  end
end
