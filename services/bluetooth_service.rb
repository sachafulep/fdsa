class BluetoothService
  class << self
    def toggle_scan(target)
      is_scanning? ? stop_scan : start_scan(target)
    end

    def start_scan(target)
      devices = []
  
      object_manager = bluez.object('/')
      object_manager.introspect
      object_manager.default_iface = 'org.freedesktop.DBus.ObjectManager'
  
      object_manager.on_signal("InterfacesAdded") do |path, interfaces|
          if interfaces.key?("org.bluez.Device1")
              device = interfaces["org.bluez.Device1"]
              name = device["Name"]
              mac_address = device["Address"]
              
              if name
                  next if devices.include?(mac_address)

                  devices.append(mac_address)

                  target.append(Device.new(name, mac_address))
              end
          end
      end
  
      adapter.StartDiscovery
  
      ap 'scanning started'
      main.run
      ap 'scanning stopped'
    end

    def stop_scan
      adapter.StopDiscovery
      main.quit
    end

    private

    def is_scanning?
      result = nil

      thread = Thread.new do
        bus = DBus::SystemBus.instance

        bluez = bus.service('org.bluez')

        object_manager = bluez.object('/')
        object_manager.introspect
        object_manager.default_iface = 'org.freedesktop.DBus.ObjectManager'

        managed_objects = object_manager.GetManagedObjects.first

        result = managed_objects["/org/bluez/hci0"]["org.bluez.Adapter1"]["Discovering"]
      end

      thread.join

      result
    end

    def bluez
      @bluez ||= bus.service('org.bluez')
    end

    def bus
      @bus ||= DBus::SystemBus.instance
    end

    def adapter
      @adapter ||= begin
        instance = bluez.object('/org/bluez/hci0')

        instance.introspect
        instance.default_iface = 'org.bluez.Adapter1'

        instance
      end
    end

    def main
      @main ||= begin
        instance = DBus::Main.new
        
        instance << bus

        instance
      end
    end
  end
end