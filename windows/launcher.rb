module Windows
  class Launcher < Gtk::Window
    def initialize
      super

      Gtk4LayerShell.init_for_window(self)

      Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::TOP, Services::DeviceService.laptop? ? 350 : 550)
      Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::TOP, 1)
      Gtk4LayerShell.set_layer(self, Gtk4LayerShell::Layer::TOP)
      Gtk4LayerShell.set_keyboard_mode(self, Gtk4LayerShell::KeyboardMode::EXCLUSIVE)

      set_transient_for($window_main)
      set_child(Widgets::Launcher::Main.new)
      add_css_class('window-launcher')
      set_can_focus(true)
      set_visible(true)
      set_visible(false)

      $windows[:launcher] = self
    end
  end
end
