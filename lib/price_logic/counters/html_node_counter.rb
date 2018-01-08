require 'nokogiri'

module PriceLogic
  module Counter
    class HTMLNodeCounter < PriceLogic::PriceLogicBase
      URL = 'http://time.com'

      class << self
        private

        def count(page)
          fetch_all_tags(page).count % CharacterCounter::REST_OF
        end

        def fetch_all_tags(page)
          html_doc = Nokogiri::HTML(page)
          html_doc.xpath("//*")
        end

        def url
          URL
        end
      end
    end
  end
end