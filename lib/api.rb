require 'faraday'
require 'faraday_middleware'

module Api
  class << self
    def client
      @client ||= new_connection
    end

    private

    def new_connection
      Faraday.new(
        url: api_uri,
        params: { company_token: my_token }
      ) do |faraday|
        faraday.headers['Content-Type'] = 'application/json'
        faraday.response :json, parser_options: { symbolize_names: true },
                                content_type: /\bjson$/
        faraday.adapter :net_http
      end
    end

    def api_uri
      "#{endpoit}/api/#{api_version}"
    end

    def endpoit
      'http://localhost:3000'
    end

    def api_version
      'v1'
    end

    def my_token
      '198f6b85969e53ee4596'
    end
  end
end