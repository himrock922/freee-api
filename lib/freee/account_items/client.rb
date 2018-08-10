# frozen_string_literal: true

module Freee
  module Api
    class AccountItems
      # 勘定項目取得用PATH
      PATH = '/api/1/account_items'
      PATH.freeze

      # A new instance of HTTP Client.
      def initialize
        @client = Faraday.new(url: Parameter::SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # 勘定項目の取得
      # https://developer.freee.co.jp/docs/accounting/reference#/Account_items/get_api_1_account_items
      # @param access_token [String] アクセストークン
      # @param params [Hash] 取得用のパラメータ
      # @return [Hash] 勘定項目取得の結果
      def get_account_items(access_token, params)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        raise '事業所IDが設定されていません' unless params.key?(:company_id)
        @client.authorization :Bearer, access_token
        response = @client.get do |req|
          req.url PATH
          req.body = params.to_json
        end
        case response.status
        when 400
          raise StandardError, response.body
        when 401
          raise 'Unauthorized'
        end
        response
      end
    end
  end
end
