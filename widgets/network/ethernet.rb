module Widgets
  module Network
    class Ethernet < Widgets::Network::Network
      def initialize
        super('Ethernet', :ethernet, data['state'])
      end

      private

      def data
        @data ||= parse_data
      end

      def parse_data
        result = `networkctl status 'enp*'`
        result = result.split(/\n/)
        
        result = result.select do |line|
          line.include?('Type') ||
          line.include?('State')
        end
        
        result = result.map do |line|
          key, value = line.split(":", 2).map(&:strip).map(&:downcase)

          [key, value]
        end.to_h
      end
    end
  end
end