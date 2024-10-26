module Widgets
  module Bar
    class Battery < Gtk::Box
      def initialize
        super(:vertical, 0)

        add_css_class('item')

        append(icon_label)
        append(Gtk::Label.new(percentage))

        GLib::Timeout.add(300000) do
          update_percentage
          
          true
        end
      end

      private

      def update_percentage
        children[0].set_text(icon)
        children[1].set_text(percentage)
      end

      def icon_label
        Gtk::Label.new(icon)
      end
      
      def icon
        Services::DeviceService.charging? ? '' : ''
      end

      def percentage
        `cat /sys/class/power_supply/BAT0/capacity`.gsub(/\n/, '')
      end
    end
  end
end