module PriceLogic
  class Config
    attr_accessor :array_counter_url,
                  :character_counter_url,
                  :html_node_counter_url,
                  :rest_of
  end

  class Configuration
    def self.config
      @@config ||= Config.new

      yield(@@config) if block_given?

      @@config
    end
  end
end