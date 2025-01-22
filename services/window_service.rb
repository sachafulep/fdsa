module Services
  class WindowService
    class << self
      def toggle_window(name)
        @name = name

        window.set_visible(!window.visible?)

        hide_children if name == :bar
        clear_launcher if name == :launcher
      end

      def window
        return unless $windows.keys.include?(@name)

        $windows[@name]
      end

      def hide_children
        $windows[:network].set_visible(false)
        $windows[:bluetooth].set_visible(false)
      end

      def clear_launcher
        window.child.entry.text = ''
      end
    end
  end
end
