module Services
  module Bluetooth
    class Listener
      class << self
        def start(callbacks)
          @listener_thread = Thread.new do
            IO.popen('bluetoothctl') do |bluetooth|
              bluetooth.each_line do |line|
                line = Bluetooth::LogLine.new(line)

                next if line.unwanted?

                callback = callbacks[line.callback_type]

                handle_callback(line, callback)
              end
            end
          end
        end

        def stop
          @listener_thread&.kill
        end

        private

        def handle_callback(line, callback)
          case line.callback_type
          when :connected, :paired, :del
            callback.call
          when :powered
            callback.call(line.positive? ? :on : :off)
          when :new
            callback.call(line.to_device)
          end
        end
      end
    end
  end
end
