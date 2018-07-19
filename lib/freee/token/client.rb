module Freee
  module Api
    class Token
      attr_reader :client
      SITE = 'https://api.freee.co.jp'
      SITE.freeze
      AUTHORIZE_URL = 'https://secure.freee.co.jp/oauth/authorize'
      AUTHORIZE_URL.freeze
      TOKEN_URL = '/oauth/token'
      TOKEN_URL.freeze

      def initialize(app_id, secret)
        options = {
          site: SITE,
          authorize_url: AUTHORIZE_URL,
          token_url: TOKEN_URL
        }
        @client = OAuth2::Client.new(app_id, secret, options)
      end

      def development_authorize(app_id)
        # MUST developmentのリダイレクトはfreeeのサーバにアクセスするため、一度freeeにログインする必要がある
        # そのため、ログイン情報を渡す必要がある。 -> Cookieで渡す?
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

      def get_access_token(code, redirect_uri)
        @client.auth_code.get_token(code, redirect_uri: redirect_uri)
      end

      def refresh_token(access_token, refresh_token, expires_at)
        params = {
          refresh_token: refresh_token,
          expires_at: expires_at
        }
        @access_token = OAuth2::AccessToken.new(@client, access_token, params)
        @access_token.refresh! if @access_token.expired?
      end
    end
  end
end
