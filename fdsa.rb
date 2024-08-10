#!/usr/bin/env ruby

Dir[File.join(__dir__, 'widgets/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'services/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'system/**/*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'windows/**/*.rb')].sort.each { |file| require file }

require 'bundler/setup'

require 'dbus'
require 'ap'

require 'gtk4_layer_shell/preload'
require 'gtk4_layer_shell'
require 'gtk4'

$windows = {}
$window_main

@application = Gtk::Application.new('org.gtk.fdsa', :flags_none)

@application.signal_connect 'activate' do |app|
    $window_main = Gtk::ApplicationWindow.new(@application)

    Bar.new
    Launcher.new
    # Bluetooth.new

    Css_loader.load
    Tcp_server.start
end

@application.run
