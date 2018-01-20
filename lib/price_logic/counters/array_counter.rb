module PriceLogic
  module Counter
    class ArrayCounter < PriceLogic::PriceLogicBase
      class << self
        private

        def count(content)
          json = JSON.load(content)
          scrap(json)
        end

        def scrap(json)
          case json
          when Hash
            json.map { |_, val| scrap(val) }.inject(:+)
          when Array
            json.map {|val| scrap(val) }.inject(json.size > 10 ? 1 : 0, :+)
          else
            0
          end
        end

        def url
          PriceLogic::Configuration.config.array_counter_url
        end
      end
    end
  end
end