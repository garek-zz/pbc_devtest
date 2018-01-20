module PriceLogic
  class ConnectionError < StandardError; end

  class PriceLogicBase
    class << self
      def url
        raise NotImplementedError
      end

      def get_price
        response = request(url)
        count(response.body)
      end

      protected

      def request(url)
        uri      = URI(url)
        response = Net::HTTP.get_response(uri)

        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          return response
        else
          raise ConnectionError, "Response error, http status: #{response.code}"
        end
      rescue Timeout::Error => e
        raise ConnectionError, e.message
      end
    end
  end
end