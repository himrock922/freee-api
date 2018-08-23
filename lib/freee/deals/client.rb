# frozen_string_literal: true

module Freee
  module Api
    class Deals
      # 取引作成用PATH
      PATH = '/api/1/deals'
      PATH.freeze

      # A new instance of HTTP Client.
      def initialize
        @client = Faraday.new(url: Parameter::SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # 取引の作成
      # https://developer.freee.co.jp/docs/accounting/reference#/Deals/post_api_1_deals
      # @param access_token [String] アクセストークン
      # @param params [Hash] 新規取引作成用のパラメータ
      # @return [Hash] 取引作成の結果
      def create_deal(access_token, params)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        raise '収入・支出の発生日が指定されていません' unless params.key?(:issue_date)
        raise '収支区分が指定されていません' unless params.key?(:type)
        raise '事業所IDが設定されていません' unless params.key?(:company_id)
        @client.authorization :Bearer, access_token
        response = @client.post do |req|
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
