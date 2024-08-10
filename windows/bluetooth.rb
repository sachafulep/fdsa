class Bluetooth < Gtk::Window
  def initialize
    super

    Gtk4LayerShell.init_for_window(self)

    # Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::TOP, 350)
    # Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::LEFT, 10)
    Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::RIGHT, 20)
    Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::TOP, 1)
    Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::RIGHT, 1)
    # Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::LEFT, 1)

    set_default_size(300, 0)
    set_transient_for($window_main)
    set_child(BluetoothWidget.new)
    add_css_class('window-bluetooth')
    set_visible(true)
    # set_visible(false)

    $windows[:bluetooth] = self
  end
end