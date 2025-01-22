module Widgets
  module Bar
    class Network < Widgets::Generic::Button
      def initialize
        super(icon: '') do
          Services::WindowService.toggle_window(:network)
        end
      end
    end
  end
end
