module Windows
  class Bluetooth < Window
    def initialize
      super(:bluetooth)

      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::LEFT, 1)
      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::BOTTOM, 1)

      set_visible(false)
    end
  end
end
