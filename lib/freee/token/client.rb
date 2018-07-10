require 'oauth2'
require 'faraday'

module Freee
  module Api
    class Token
      def initialize(app_id, secret)
        options = {
          site: "https://api.freee.co.jp/",
          authorize_url: 'https://secure.freee.co.jp/oauth/authorize',
          token_url: '/oauth/token'
        }
        @client = OAuth2::Client.new(app_id, secret, options) do |conn|
          conn.request :url_encoded
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end

      def development_authorize(app_id)
        client = Faraday.new(url: "https://secure.freee.co.jp")
        res = client.get do |req|
          req.url "/oauth/authorize",
          req.params = {
            client_id: app_id,
            redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
            response_type: "code"
          }
        end
        res.body
      end
    
      def authorize(redirect_uri)
        @client.auth_code.authorize_url(redirect_uri: redirect_uri)
      end

      def get_access_token(code)
        token = @client.auth_code.get_token(code, redirect_uri: "https://api.freee.co.jp/oauth/token")
      end
    end
  end
end