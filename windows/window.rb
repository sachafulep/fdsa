module Windows
  class Window < Gtk::Window
    def initialize(name)
      super()

      Gtk4LayerShell.init_for_window(self)

      set_transient_for($windows[:main])

      set_child(Widgets.const_get(name.capitalize)::Main.new)

      add_css_class("window-#{name}")

      $windows[name] = self
    end
  end
end
