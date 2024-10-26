module Widgets
  module Bar
    class Clock < Gtk::Box
      def initialize
        super(:vertical, 0)

        add_css_class('item')

        append(icon)
        append(Gtk::Label.new(hour))
        append(Gtk::Label.new(minute))

        GLib::Timeout.add(60000) do
          update_time
          
          true
        end
      end

      private

      def update_time
        children[1].set_text(hour)
        children[2].set_text(minute)
      end

      def icon
        Gtk::Label.new('')
      end

      def hour
        Time.now.strftime('%H')
      end

      def minute
        Time.now.strftime('%M')
      end
    end
  end
end