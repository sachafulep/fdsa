require 'bundler/setup'
require 'gtk4_layer_shell/preload'
require 'gtk4_layer_shell'
require 'gtk4'

module Widgets
  module Launcher
    class Main < Gtk::Box
      def initialize(window)
        super(:horizontal)

        @window = window

        add_css_class('launcher')

        connect_signals

        append(label)
        append(entry)
      end

      def grab_focus
        entry.grab_focus
      end

      def entry
        @entry ||= begin
          instance = Gtk::Entry.new
          
          instance.set_can_focus(true)
          instance.set_focusable(true)
          instance.set_sensitive(true)
          instance.set_has_frame(false)
          instance.add_css_class('launcher__entry')

          instance
        end
      end

      private

      def connect_signals
        entry.signal_connect('activate') do
          command = entry.text.strip

          Thread.new { system(parse_command(command)) }

          entry.text = ''

          @window.set_visible(false)
        end
      end

      def parse_command(command)
        case command
        when 'spotify'
          'spotify-launcher --skip-update'
        else
          command
        end
      end

      def label
        instance = Gtk::Label.new('')
        
        instance.add_css_class('launcher__label')

        instance
      end
    end
  end
end