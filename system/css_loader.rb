module System
  class Css_loader
    class << self
      def load
        css_provider.load(data: css_data)
      
        Gtk::StyleContext.add_provider_for_display(
          Gdk::Display.default,
          css_provider,
          Gtk::StyleProvider::PRIORITY_USER
        )
      end

      def project_root
        File.dirname(File.expand_path($0))
      end

      def css_data
        File.read(File.join(project_root, 'styles.css'))
      end

      def css_provider
        @css_provider ||= Gtk::CssProvider.new
      end
    end
  end
end