module Freee
    module Api
      class Partners
        SITE = 'https://api.freee.co.jp'
        SITE.freeze
        POST = '/api/1/partners'
        POST.freeze

        def initialize
          @client = Faraday.new(url: SITE) do |faraday|
            faraday.request :url_encoded
            faraday.request :json
            faraday.response :json, content_type: /\bjson$/
            faraday.adapter Faraday.default_adapter
          end
        end

        def create_partner(access_token, params)
          @client.post do |req|
            req.url POST
            req.headers['Content-Type'] = 'application/json'
            req.headers['Authorization'] = "Bearer #{access_token}"
            req.body = params
          end
        end
      end
    end
  end
  