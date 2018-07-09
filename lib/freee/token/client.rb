require 'oauth2'
module Freee
  module Api
    class Token
      def initialize(app_id, secret)
        @client = OAuth2::Client.new(
          app_id,
          secret,
          site: "https://secure.freee.co.jp/"
        )
      end

      def development_authorize
        @client.auth_code.authorize_url(redirect_uri: "urn:ietf:wg:oauth:2.0:oob")
      end

      def get_access_token(code)
        token = @client.auth_code.authorize_url(code, redirect_uri: "https://api.freee.co.jp/oauth/token")
      end
    end
  end
end