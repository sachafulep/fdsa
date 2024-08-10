class ConnectedDevices < Gtk::ScrolledWindow
  def initialize
    super

    height =
        case 1
        when 0, 1 then 40
        when 2 then 80
        else 120
        end
    
    vexpand = true
    hexpand = true
    set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
    add_css_class('bluetooth-devices')
    set_min_content_height(40)
    set_child(paired_devices)
  end

  private

  def paired_devices
    box = Gtk::Box.new(:vertical, 5)

    output = `bluetoothctl devices Paired`.split("\n")

    output.each do |line|
        mac_address = line.split[1]
        name = line.split(mac_address)[1].strip

        box.append(Device.new(name, mac_address))
    end

    box
  end
end