require 'nokogiri'

module PriceLogic
  module Counter
    class HTMLNodeCounter < PriceLogic::PriceLogicBase
      class << self
        private

        def count(page)
          fetch_all_tags(page).count % PriceLogic::Configuration.config.rest_of
        end

        def fetch_all_tags(page)
          html_doc = Nokogiri::HTML(page)
          html_doc.xpath("//*")
        end

        def url
          PriceLogic::Configuration.config.html_node_counter_url
        end
      end
    end
  end
end