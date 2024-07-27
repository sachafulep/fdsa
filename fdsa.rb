$LOAD_PATH.unshift(File.join(__dir__, 'widgets'))

Dir[File.join(__dir__, 'widgets', '*.rb')].each do |file|
    require File.basename(file, '.rb')
end

require 'socket'

require 'bundler/setup'
require 'gtk4_layer_shell/preload'
require 'gtk4_layer_shell'
require 'gtk4'

@application = Gtk::Application.new('org.gtk.fdsa', :flags_none)

@application.signal_connect 'activate' do |app|
    @window_main = Gtk::ApplicationWindow.new(@application)

    create_bar
    create_launcher

    load_css

    start_server
end

def create_bar
    @window_bar = Gtk::Window.new

    @window_bar.set_transient_for(@window_main)

    Gtk4LayerShell.init_for_window(@window_bar)
    Gtk4LayerShell.auto_exclusive_zone_enable(@window_bar)

    Gtk4LayerShell.set_margin(@window_bar, Gtk4LayerShell::Edge::TOP, 10)
    Gtk4LayerShell.set_margin(@window_bar, Gtk4LayerShell::Edge::BOTTOM, 10)
    Gtk4LayerShell.set_margin(@window_bar, Gtk4LayerShell::Edge::LEFT, 30)

    Gtk4LayerShell.set_anchor(@window_bar, Gtk4LayerShell::Edge::LEFT, 1)

    @window_bar.set_default_size(0, 1380)
    @window_bar.set_child(Bar.new)
    @window_bar.set_visible(true)
end

def create_launcher
    @window_launcher = Gtk::Window.new

    Gtk4LayerShell.init_for_window(@window_launcher)
    Gtk4LayerShell.set_layer(@window_launcher, Gtk4LayerShell::Layer::TOP)
    Gtk4LayerShell.set_keyboard_mode(@window_launcher, Gtk4LayerShell::KeyboardMode::EXCLUSIVE)

    @launcher = Launcher.new(@window_launcher)
    @entry = @launcher.entry

    @window_launcher.set_transient_for(@window_main)
    @window_launcher.set_child(@launcher)
    @window_launcher.set_can_focus(true)
    @window_launcher.set_visible(true)
    @window_launcher.set_visible(false)
end

def load_css
    css_provider = Gtk::CssProvider.new
    css_file_path = File.join(File.dirname(__FILE__), 'styles.css')
    css_data = File.read(css_file_path)
    display = Gdk::Display.default

    css_provider.load(data: css_data)

    Gtk::StyleContext.add_provider_for_display(
        display,
        css_provider,
        Gtk::StyleProvider::PRIORITY_USER
    )
end    

def start_server
    server = TCPServer.new(12345)

    Thread.new do
        loop do
            client = server.accept

            message = client.gets.chomp

            if message == 'bar'
                @window_bar.set_visible(!@window_bar.visible?)
            elsif message == 'launcher'
                @window_launcher.set_visible(!@window_launcher.visible?)

                @entry.text = ''
            end

            client.close
        end
    end
end

@application.run
