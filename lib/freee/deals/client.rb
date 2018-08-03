# frozen_string_literal: true

module Freee
    module Api
      class Deals
        # 取引作成URL(POST)
        POST = '/api/1/deals'
        POST.freeze
  
        # A new instance of HTTP Client.
        def initialize
          @client = Faraday.new(url: Parameter::SITE) do |faraday|
            faraday.request :json
            faraday.response :json, content_type: /\bjson$/
            faraday.adapter Faraday.default_adapter
          end
        end
  
        # 取引の作成
        # https://developer.freee.co.jp/docs/accounting/reference#operations-Partners-post_api_1_partners
        # @param access_token [String] アクセストークン
        # @param params [Hash] 新規取引作成用のパラメータ
        # @return [Hash] 取引作成の結果
        def create_deal(access_token, params)
          @client.authorization :Bearer, access_token
          response = @client.post do |req|
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
  