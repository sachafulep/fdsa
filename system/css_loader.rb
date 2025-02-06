module System
  class CssLoader
    class << self
      def load
        css_provider.load(data: css_data)

        Gtk::StyleContext.add_provider_for_display(
          Gdk::Display.default,
          css_provider,
          Gtk::StyleProvider::PRIORITY_USER
        )
      end

      def css_data
        css_files.reduce('') { |data, file| data << File.read(file) }
      end

      def css_files
        [main_css_file, other_css_files].flatten
      end

      def main_css_file
        File.join(project_root, 'styles.css')
      end

      def other_css_files
        other_css_file_names.map {|file| File.join(styles_folder, file) }
      end

      def other_css_file_names
        Dir.entries(styles_folder).select do |file|
          File.file?(File.join(styles_folder, file))
        end
      end

      def styles_folder
        "#{project_root}/styles"
      end

      def project_root
        File.dirname(File.expand_path($0))
      end

      def css_provider
        @css_provider ||= Gtk::CssProvider.new
      end
    end
  end
end
