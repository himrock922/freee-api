# frozen_string_literal: true

module Freee
  module Api
    class Sections
      # 部門取得用PATH
      PATH = '/api/1/sections'
      PATH.freeze

      # A new instance of HTTP Client.
      def initialize
        @client = Faraday.new(url: Parameter::SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # 部門一覧の取得
      # https://developer.freee.co.jp/docs/accounting/reference#/Sections/get_api_1_sections
      # @param access_token [String] アクセストークン
      # @param params [Hash] 新規作成用の取引先パラメータ
      # @return [Hash] GETレスポンスの結果
      def get_sections(access_token, params)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        raise '事業所IDが設定されていません' unless params.key?(:company_id)
        @client.authorization :Bearer, access_token
        response = @client.get do |req|
          req.url PATH
          req.body = params.to_json
        end
        case response.status
        when 401
          raise 'Unauthorized'
        end
        response
      end
    end
  end
end
