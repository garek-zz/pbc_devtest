require 'nokogiri'

module PriceLogic
  module Counter
    class CharacterCounter < PriceLogic::PriceLogicBase
      URL     = 'http://time.com'

      class << self
        private

        def count(page)
          fetch_all_chars(page) % CharacterCounter::REST_OF
        end

        def fetch_all_chars(page)
          html_doc = Nokogiri::HTML(page)
          html_doc.inner_text.scan(/a/).count
        end

        def url
          URL
        end
      end
    end
  end
end