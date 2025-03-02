module Windows
  class Launcher < Window
    def initialize
      super(:launcher)

      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::TOP, 1)
      Gtk4LayerShell.set_layer(self, Gtk4LayerShell::Layer::TOP)
      Gtk4LayerShell.set_keyboard_mode(self, Gtk4LayerShell::KeyboardMode::EXCLUSIVE)

      set_can_focus(true)
      set_visible(true)
      set_visible(false)
    end
  end
end
