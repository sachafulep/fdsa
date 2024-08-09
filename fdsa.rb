#!/usr/bin/env ruby

Dir[File.join(__dir__, 'widgets/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'services/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'system/**/*.rb')].sort.each { |file| require file }

require 'bundler/setup'
require 'gtk4_layer_shell/preload'
require 'gtk4_layer_shell'
require 'gtk4'

$windows = {}

@application = Gtk::Application.new('org.gtk.fdsa', :flags_none)

@application.signal_connect 'activate' do |app|
    @window_main = Gtk::ApplicationWindow.new(@application)

    create_bar
    create_launcher
    create_bluetooth

    Css_loader.load
    Tcp_server.start
end

def create_bar
    window = Gtk::Window.new

    Gtk4LayerShell.init_for_window(window)

    Gtk4LayerShell.auto_exclusive_zone_enable(window)

    Gtk4LayerShell.set_margin(window, Gtk4LayerShell::Edge::TOP, 10)
    Gtk4LayerShell.set_margin(window, Gtk4LayerShell::Edge::BOTTOM, 10)
    Gtk4LayerShell.set_margin(window, Gtk4LayerShell::Edge::LEFT, 30)
    Gtk4LayerShell.set_anchor(window, Gtk4LayerShell::Edge::LEFT, 1)

    window.set_transient_for(@window_main)
    window.set_default_size(0, DeviceService.laptop? ? 1007 : 1380)
    window.set_child(Bar.new)
    window.add_css_class('window-bar')
    window.set_visible(true)

    $windows[:bar] = window
end

def create_launcher
    window = Gtk::Window.new

    Gtk4LayerShell.init_for_window(window)

    Gtk4LayerShell.set_margin(window, Gtk4LayerShell::Edge::TOP, DeviceService.laptop? ? 350 : 550)
    Gtk4LayerShell.set_anchor(window, Gtk4LayerShell::Edge::TOP, 1)
    Gtk4LayerShell.set_layer(window, Gtk4LayerShell::Layer::TOP)
    Gtk4LayerShell.set_keyboard_mode(window, Gtk4LayerShell::KeyboardMode::EXCLUSIVE)

    window.set_transient_for(@window_main)
    window.set_child(Launcher.new(window))
    window.add_css_class('window-launcher')
    window.set_can_focus(true)
    window.set_visible(true)
    window.set_visible(false)

    $windows[:launcher] = window
end

def create_bluetooth
    window = Gtk::Window.new

    Gtk4LayerShell.init_for_window(window)

    # Gtk4LayerShell.set_margin(window, Gtk4LayerShell::Edge::TOP, 350)
    # Gtk4LayerShell.set_margin(window, Gtk4LayerShell::Edge::LEFT, 10)
    Gtk4LayerShell.set_margin(window, Gtk4LayerShell::Edge::RIGHT, 20)
    Gtk4LayerShell.set_anchor(window, Gtk4LayerShell::Edge::TOP, 1)
    Gtk4LayerShell.set_anchor(window, Gtk4LayerShell::Edge::RIGHT, 1)
    # Gtk4LayerShell.set_anchor(window, Gtk4LayerShell::Edge::LEFT, 1)

    window.set_default_size(300, 0)
    window.set_transient_for(@window_main)
    window.set_child(Bluetooth.new)
    window.add_css_class('window-bluetooth')
    window.set_visible(true)
    # window.set_visible(false)

    $windows[:bluetooth] = window
end

@application.run
