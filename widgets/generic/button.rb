module Widgets
  module Generic
    class Button < Gtk::Box
      def initialize(orientation: :vertical, icon: '?', command: nil, &block)
        super(orientation)

        @icon = Gtk::Label.new(icon)
        @command = command
        @block = block

        add_css_class('item')

        set_vexpand(false)
        set_size_request(40, 40)
        set_cursor(Gdk::Cursor.new('pointer'))

        setup_icon
        set_click_action
      end

      def set_icon(icon)
        @icon.set_text(icon)
      end

      private

      def setup_icon
        @icon.set_vexpand(true)

        append(@icon)
      end

      def set_click_action
        click_gesture = Gtk::GestureClick.new

        click_gesture.signal_connect('pressed') do |gesture, n_press, x, y|
          Thread.new { system(@command) } if @command

          @block.call if @block
        end
      
        add_controller(click_gesture)
      end
    end
  end
end