module Services
  class WindowService
    class << self
      def toggle_window(name)
        window(name).set_visible(!window(name).visible?)

        hide_children if name == :bar
        clear_launcher if name == :launcher
      end

      def window(name)
        return unless $windows.keys.include?(name)

        $windows[name]
      end

      private

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
