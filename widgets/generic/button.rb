module Widgets
  module Generic
    class Button < Gtk::Button
      def initialize(
        label: '?',
        small: false,
        inverted_colors: false,
        &block
      )
        super(label: nil)

        add_css_class('item')
        add_css_class('button')
        add_css_class('button--inverted-colors') if inverted_colors
        add_css_class('button--small') if small

        set_size_request(small ? 25 : 40, small ? 25 : 40)
        set_cursor(Gdk::Cursor.new('pointer'))
        set_child(Gtk::Label.new(label))

        signal_connect('clicked') { block.call }
      end
    end
  end
end
