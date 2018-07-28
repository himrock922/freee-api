# frozen_string_literal: true

module Freee
  module Api
    class Partners
      # Freee API URL
      SITE = 'https://api.freee.co.jp'
      SITE.freeze
      # 取引先作成URL(POST)
      POST = '/api/1/partners'
      POST.freeze

      # A new instance of HTTP Client.
      def initialize
        @client = Faraday.new(url: SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # 取引先の作成
      # https://developer.freee.co.jp/docs/accounting/reference#operations-Partners-post_api_1_partners
      # @param access_token [String] アクセストークン
      # @param params [Hash] 新規作成用の取引先パラメータ
      # @return [Hash] 取引先の結果
      def create_partner(access_token, params)
        @client.authorization :Bearer, access_token
        response =　@client.post do |req|
          req.url POST
          req.body = params.to_json
        end
        case response.status
        when 401
          raise 'Unauthorized', response.body
        end
      end
    end
  end
end
