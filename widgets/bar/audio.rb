require 'rb-inotify'

module Widgets
  module Bar
    class Audio < Gtk::Box
      FILE_PATH = '/tmp/volume_level'

      def initialize
        start_notifier
      end

      def revealer
        trigger = revealer_trigger
        child = revealer_buttons

        Revealer.new(trigger: trigger, child: child)
      end

      private

      def revealer_trigger
        box = Gtk::Box.new(:vertical)

        box.add_css_class('item')

        volume = `~/Documents/scripts/audio/get_volume.sh`

        @volume_label = Gtk::Label.new(volume.gsub(/\n/, ''))

        @volume_label.set_vexpand(false)

        box.append(icon)
        box.append(@volume_label)
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
        @volume_label.set_text(volume.gsub(/\n/, ''))
      end

      def icon
        label = Gtk::Label.new('')
    
        label.add_css_class('item__icon')
    
        label
      end

      def start_notifier
        Thread.new do
          notifier = INotify::Notifier.new

          notifier.watch(FILE_PATH, :modify) do
            File.open(FILE_PATH, 'r') do |file|
              file.seek(0, IO::SEEK_SET)

              new_line = file.gets

              handle_volume_change(new_line) if new_line
            end
          end

          notifier.run
        end
      end
    end
  end
end