module Widgets
  module Generic
    class Revealer < Gtk::Box
      def initialize(trigger: nil, child: nil)
        super(:vertical, 0)

        unless trigger.is_a?(Gtk::Button)
          raise ArgumentError, "trigger must be a Gtk::Button"
        end

        @trigger = trigger
        @child = child

        set_revealer_signal

        append(revealer)
        append(trigger)
      end

      def revealed?
        revealer.reveal_child?
      end

      def hide
        revealer.set_reveal_child(false)
      end

      private

      def revealer
        @revealer ||= begin
          instance = Gtk::Revealer.new

          instance.set_transition_type(:slide_up)
          instance.set_transition_duration(400)
          instance.set_child(@child)

          instance
        end
      end

      def set_revealer_signal
        @trigger.signal_connect('clicked') do
          revealer.set_reveal_child(!revealed?)
        end
      end
    end
  end
end
