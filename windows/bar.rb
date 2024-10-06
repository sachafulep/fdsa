class Bar < Gtk::Window
  def initialize
    super

    Gtk4LayerShell.init_for_window(self)

    Gtk4LayerShell.auto_exclusive_zone_enable(self)

    Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::TOP, 10)
    Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::BOTTOM, 10)
    Gtk4LayerShell.set_margin(self, Gtk4LayerShell::Edge::LEFT, 30)
    Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::LEFT, 1)

    set_transient_for($window_main)
    set_default_size(0, DeviceService.laptop? ? 1007 : 1380)
    set_child(BarWidget.new)
    add_css_class('window-bar')
    set_visible(true)

    $windows[:bar] = self
  end
end