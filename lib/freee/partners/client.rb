# frozen_string_literal: true

module Freee
  module Api
    class Partners
      # 取引先作成・取得・更新用PATH
      PATH = '/api/1/partners'
      PATH.freeze

      # A new instance of HTTP Client.
      def initialize
        @client = Faraday.new(url: Parameter::SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # 取引先の取得
      # @param access_token [String] アクセストークン
      # @param params [Hash] 新規作成用の取引先パラメータ
      # @return [Hash] GETレスポンスの結果
      def get_partners(access_token, params)
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

      # 取引先の作成
      # https://developer.freee.co.jp/docs/accounting/reference#operations-Partners-post_api_1_partners
      # @param access_token [String] アクセストークン
      # @param params [Hash] 新規作成用の取引先パラメータ
      # @return [Hash] POSTレスポンスの結果
      def create_partner(access_token, params)
        @client.authorization :Bearer, access_token
        response = @client.post do |req|
          req.url PATH
          req.body = params.to_json
        end
        case response.status
        when 401
          raise 'Unauthorized'
        end
        response
      end

      # 取引先の更新
      # https://developer.freee.co.jp/docs/accounting/reference#/Partners/put_api_1_partners_id
      # @param access_token [String] アクセストークン
      # @param params [Hash] 更新用の取引先パラメータ
      # @return [Hash] PUTレスポンスの結果
      def update_partner(access_token, params)
        raise 'アクセストークンが設定されていません' if access_token.empty?
        raise '事業所IDが設定されていません' unless params.key?(:company_id)
        raise '取引先IDが設定されていません' unless params.key?(:id)
        raise '取引先名が設定されていません' unless params.key?(:name)
        @client.authorization :Bearer, access_token
        response = @client.put do |req|
          req.url PATH + '/' + params[:id].to_s
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
