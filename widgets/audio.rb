require 'rb-inotify'

require 'bundler/setup'
require 'gtk4_layer_shell/preload'
require 'gtk4_layer_shell'
require 'gtk4'

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

        volume = File.readlines(FILE_PATH).first

        @volume_label = Gtk::Label.new(volume.gsub(/\n/, ''))

        @volume_label.set_vexpand(false)

        box.append(icon)
        box.append(@volume_label)
    end

    def revealer_buttons
        box = Gtk::Box.new(:vertical, 10)
        script = '~/Documents/scripts/audio/change_sink.sh'

        {
            '': "#{script} WH-1000XM4",
            '': "#{script} DragonFly Red Analog Stereo",
            '': "#{script} Schiit Modi 3 Analog Stereo"
        }.each do |icon, command|
            button = Button.new(icon: icon, command: command)

            if command == "#{script} Schiit Modi 3 Analog Stereo"
                button.add_css_class('first-revealer-item')
            end

            box.append(button)
        end

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