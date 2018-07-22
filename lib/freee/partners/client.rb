# frozen_string_literal: true

module Freee
  module Api
    class Partners
      SITE = 'https://api.freee.co.jp'
      SITE.freeze
      POST = '/api/1/partners'
      POST.freeze

      def initialize
        @client = Faraday.new(url: SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      def create_partner(access_token, params)
        @client.authorization :Bearer, access_token
        @client.post do |req|
          req.url POST
          req.body = params.to_json
        end
      end
    end
  end
end
