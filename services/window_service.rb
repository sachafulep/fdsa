module Services
  class WindowService
    class << self
      def toggle_window(name)
        window(name).set_visible(!window(name).visible?)

        perform_side_effects
      end

      def set_window(name, state)
        window(name).set_visible(state)

        perform_side_effects if !state
      end

      def window(name)
        return unless $windows.keys.include?(name)

        $windows[name]
      end

      private

      def perform_side_effects
        hide_children if name == :bar
        clear_launcher if name == :launcher
      end

      def hide_children
        $windows[:network].set_visible(false)
        $windows[:bluetooth].set_visible(false)
      end

      def clear_launcher
        window(:launcher).child.entry.text = ''
      end
    end
  end
end
