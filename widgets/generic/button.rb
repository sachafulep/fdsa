module Widgets
  module Generic
    class Button < Gtk::Box
      def initialize(
        orientation: :vertical,
        icon: '?',
        small: false,
        inverse_colors: false,
        command: nil,
        &block
      )
        super(orientation)

        @icon = Gtk::Label.new(icon)
        @small = small
        @command = command
        @block = block

        add_css_class('item')
        add_css_class('item--small') if small
        add_css_class('item--inverse-colors') if inverse_colors

        set_vexpand(false)
        set_size_request(size, size)
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
      
      def size
        @small ? 25 : 40
      end
    end
  end
end