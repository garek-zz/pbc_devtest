require 'nokogiri'

module PriceLogic
  module Counter
    class CharacterCounter < PriceLogic::PriceLogicBase
      class << self
        private

        def count(page)
          fetch_all_chars(page) % PriceLogic::Configuration.config.rest_of
        end

        def fetch_all_chars(page)
          html_doc = Nokogiri::HTML(page)
          html_doc.inner_text.scan(/a/).count
        end

        def url
          PriceLogic::Configuration.config.character_counter_url
        end
      end
    end
  end
end