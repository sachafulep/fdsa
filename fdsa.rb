#!/usr/bin/env ruby

require 'bundler/setup'
require 'ap'
require 'zeitwerk'
require 'gtk4_layer_shell/preload'
require 'gtk4_layer_shell'
require 'gtk4'

require_relative 'system/css_loader'
require_relative 'system/tcp_server'

loader = Zeitwerk::Loader.new
loader.push_dir(__dir__)
loader.setup

$windows = {}
$window_main

@application = Gtk::Application.new('org.gtk.fdsa', :flags_none)

@application.signal_connect 'activate' do |app|
  $window_main = Gtk::ApplicationWindow.new(@application)

  Windows::Bar.new
  Windows::Launcher.new
  Windows::Network.new
  Windows::Bluetooth.new

  System::Css_loader.load
  System::Tcp_server.start
end

@application.run
