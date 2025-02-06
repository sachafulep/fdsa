module Windows
  class Network < Window
    def initialize
      super(:network)

      Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::LEFT, 15)
      Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::BOTTOM, 210)
      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::LEFT, 1)
      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::BOTTOM, 1)

      set_visible(false)
    end
  end
end
