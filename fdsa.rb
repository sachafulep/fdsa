#!/usr/bin/env ruby

ENV['GTK_THEME'] = 'Adwaita'

require 'bundler/setup'
require 'ap'
require 'zeitwerk'
require 'gtk4_layer_shell/preload'
require 'gtk4_layer_shell'
require 'gtk4'

loader = Zeitwerk::Loader.new
loader.push_dir(__dir__)
loader.setup

$windows = {}
$widgets = {}

@application = Gtk::Application.new('org.gtk.fdsa', :flags_none)

@application.signal_connect 'activate' do |_|
  $windows[:main] = Gtk::ApplicationWindow.new(@application)

  Windows::Bar.new
  Windows::Launcher.new
  Windows::Network.new
  Windows::Bluetooth.new

  System::CssLoader.load
  System::TcpServer.start
end

@application.run
