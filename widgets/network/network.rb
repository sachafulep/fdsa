module Widgets
  module Network
    class Network < Gtk::CenterBox
      def initialize(name, type, state)
        super()

        add_css_class('network__network')

        status = Gtk::Label.new('')

        icon = state == 'routable (configured)' ? '' : ''
        
        status.set_text(icon)

        set_hexpand(true)

        set_start_widget(Gtk::Label.new('Ethernet'))
        set_end_widget(status)
      end
    end
  end
end