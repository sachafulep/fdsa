require 'rb-inotify'

module Widgets
  module Bar
    class Audio < Gtk::Box
      FILE_PATH = '/tmp/volume_level'

      def initialize
        File.open(FILE_PATH, 'w').close unless File.exist?(FILE_PATH)

        start_notifier
      end

      def revealer
        trigger = revealer_trigger
        child = revealer_buttons

        Widgets::Generic::Revealer.new(trigger: trigger, child: child)
      end

      private

      def revealer_trigger
        box = Gtk::Box.new(:vertical)

        box.add_css_class('item')

        volume = `~/Documents/scripts/audio/get_volume.sh`.gsub(/\n/, '')

        $widgets[:volume] = Gtk::Label.new(volume)

        $widgets[:volume].set_vexpand(false)

        if volume.empty?
          Thread.new do
            loop do
              volume = `~/Documents/scripts/audio/get_volume.sh`.gsub(/\n/, '')
              break unless volume.empty?
              sleep 0.5
            end
            handle_volume_change(volume)
          end
        end

        box.append(icon)
        box.append($widgets[:volume])
      end

      def revealer_buttons
        box = Gtk::Box.new(:vertical, 10)
        script = '~/Documents/scripts/audio/change_sink.sh'
        button = nil

        {
          '': "#{script} #{Services::DeviceService.bluetooth_device_name}",
          '': "#{script} #{Services::DeviceService.speaker_device_name}",
          '': "#{script} #{Services::DeviceService.headphone_device_name}"
        }.each do |icon, command|
          button = Widgets::Generic::Button.new(icon: icon, command: command)

          box.append(button)
        end

        button.add_css_class('first-revealer-item')

        box
      end

      def handle_volume_change(volume)
        $widgets[:volume].set_text(volume)
      end

      def icon
        Gtk::Label.new('')
      end

      def start_notifier
        Thread.new do
          notifier = INotify::Notifier.new

          notifier.watch(FILE_PATH, :modify) do
            File.open(FILE_PATH, 'r') do |file|
              file.seek(0, IO::SEEK_SET)

              new_line = file.gets

              handle_volume_change(new_line.gsub(/\n/, '')) if new_line
            end
          end

          notifier.run
        end
      end
    end
  end
end
