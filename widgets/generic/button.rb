module Widgets
  module Generic
    class Button < Gtk::Button
      def initialize(
        label: '?',
        child: nil,
        small: false,
        inverted_colors: false,
        &block
      )
        super(label: nil)

        @label = label
        @child = child

        add_css_class('item')
        add_css_class('button')
        add_css_class('button--inverted-colors') if inverted_colors
        add_css_class('button--small') if small

        set_size_request(small ? 25 : 40, small ? 25 : 40)
        set_cursor(Gdk::Cursor.new('pointer'))
        set_child(default_child)

        signal_connect('clicked') { block.call if block }
      end

      private

      def default_child
        return @child unless @child.nil?

        Gtk::Label.new(@label)
      end
    end
  end
end
