module PriceLogic
  class ConnectionException < Exception; end

  class PriceLogicBase
    REST_OF = 100

    class << self
      def url
        raise NotImplementedError
      end

      def get_price
        page = request(url)
        count(page)
      end

      protected

      def request(url)
        uri = URI(url)
        response = Net::HTTP.get_response(uri)

        case response
          when Net::HTTPSuccess, Net::HTTPRedirection
            return response.body
          else
            raise PriceLogic::ConnectionException.new("Connection exception, http status: #{response.code}")
        end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        raise PriceLogic::ConnectionException.new(e.message)
      end
    end
  end
end