module Widgets
  module Launcher
    class Main < Gtk::Box
      def initialize
        super(:horizontal)

        add_css_class('launcher')

        connect_signals

        enable_autocomplete

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
          instance.set_overwrite_mode(true)
          instance.add_css_class('launcher__entry')

          instance
        end
      end

      private

      def enable_autocomplete
        @handler = entry.signal_connect('changed') do
          @current_text = entry.text

          if entry.position == 0
            update_text('')

            next
          end

          next if @current_text == '' || autocomplete_terms.include?(@current_text)

          suggestions = autocomplete_suggestions

          if suggestions.any?
            update_text(suggestions.first)
          elsif @current_text.length > entry.position
            update_text(@current_text[0..(entry.position - 1)])

            @current_text = entry.text

            suggestions = autocomplete_suggestions

            update_text(suggestions.first) if suggestions.any?
          end

          false
        end
      end

      def autocomplete_terms
        terms = [
          'firefox',
          'code',
          'spotify',
          'heroic',
          'steam',
          'android-studio',
          'zen',
          'zeditor'
        ]
      end

      def autocomplete_suggestions
        autocomplete_terms.select { |term| term.start_with?(entry.text) }
      end

      def update_text(text)
        entry.signal_handler_block(@handler)
        entry.text = text
        entry.signal_handler_unblock(@handler)
        entry.position = @current_text.length
      end

      def connect_signals
        entry.signal_connect('activate') do
          command = entry.text.strip

          Thread.new { system(parse_command(command)) }

          entry.text = ''

          Services::WindowService.toggle_window(:launcher)
        end
      end

      def parse_command(command)
        case command
        when 'spotify'
          'spotify-launcher'
        when 'code'
          'ELECTRON_OZONE_PLATFORM_HINT=wayland code'
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
