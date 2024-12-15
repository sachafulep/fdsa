module Windows
  class Network < Gtk::Window
    def initialize
      super

      Gtk4LayerShell.init_for_window(self)
      Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::LEFT, 15)
      Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::BOTTOM, 210)
      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::LEFT, 1)
      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::BOTTOM, 1)

      set_transient_for($window_main)
      set_child(Widgets::Network::Main.new)
      add_css_class('window-network')
      set_visible(false)

      $windows[:network] = self
    end
  end
end