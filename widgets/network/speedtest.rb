module Widgets
  module Network
    class Speedtest < Gtk::CenterBox
      def initialize
        super

        @result = Gtk::Label.new('-')

        set_hexpand(true)
        set_start_widget(down)
        set_end_widget(start)
      end

      private

      def down
        box = Gtk::Box.new(:horizontal, 10)

        box.add_css_class('network__top-bar-download')

        box.append(Gtk::Label.new(''))
        box.append(@result)

        box
      end

      def start
        button = Widgets::Generic::Button.new(label: '') do
          Thread.new do
            button.set_label('')
            result = `speedtest --csv --no-upload --secure`
            speed = (result.split(',')[6].to_f / 1000000).to_i

            @result.set_text(speed.to_s)
            button.set_label('')
          end
        end

        button
      end
    end
  end
end
