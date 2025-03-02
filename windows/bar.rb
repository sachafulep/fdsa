module Windows
  class Bar < Window
    def initialize
      super(:bar)

      Gtk4LayerShell.auto_exclusive_zone_enable(self)
      Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::LEFT, 30)
      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::LEFT, 1)

      set_visible(true)
    end
  end
end
