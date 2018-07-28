# frozen_string_literal: true

module Freee
  module Api
    class Token
      # oauth-xx client(read only)
      attr_reader :client
      # Freee API URL
      SITE = 'https://api.freee.co.jp'
      SITE.freeze
      # Freee 開発環境用認証コードURL
      DEVELOPMENT_REDIRECT_URL = 'urn:ietf:wg:oauth:2.0:oob'
      DEVELOPMENT_REDIRECT_URL.freeze
      # Freee 認証コードURL
      AUTHORIZE_URL = 'https://secure.freee.co.jp/oauth/authorize'
      AUTHORIZE_URL.freeze
      # Freee Token URL
      TOKEN_URL = '/oauth/token'
      TOKEN_URL.freeze

      # A new instance of OAuth2 Client.
      # @param app_id [String] Application ID
      # @param secret [String] Secret
      def initialize(app_id, secret)
        options = {
          site: SITE,
          authorize_url: AUTHORIZE_URL,
          token_url: TOKEN_URL
        }

        if app_id.empty?
          raise 'アプリケーションIDが入力されていません'
        end

        if secret.empty?
          raise 'Secretが入力されていません'
        end
        @client = OAuth2::Client.new(app_id, secret, options)
      end

      # 開発環境用に認証コード・アクセストークンのコールバックURLを生成
      # @return [String] Freee 開発環境用認証コード・アクセストークン取得用URL
      def development_authorize
        @client.auth_code.authorize_url(redirect_uri: DEVELOPMENT_REDIRECT_URL)
      end

      # 本番環境用に認証コード・アクセストークンのコールバックURLを生成
      # @param redirect_uri [String] redirect_url for Authentication Code
      # @return [String] Freee 本番環境用認証コードURL
      def authorize(redirect_uri)
        if redirect_uri.empty?
          raise '認証用コードを返すためのリダイレクトURLが指定されていません'
        end
        @client.auth_code.authorize_url(redirect_uri: redirect_uri)
      end

      # アクセストークン関係のパラメータを取得
      # @param code [String] Authentication Code
      # @param redirect_uri [String] redirect_url for Access Token
      # @return [Hash] アクセストークン
      def get_access_token(code, redirect_uri)
        if code.empty?
          raise '認証用コードが存在しません'
        end
        if redirect_uri.empty?
          raise 'アクセストークンを返すためのリダイレクトURLが指定されていません'
        end
        begin
          @client.auth_code.get_token(code, redirect_uri: redirect_uri)
        rescue OAuth2::Error
          raise 'アクセストークンの取得に失敗しました。次の原因が考えられます。原因: 不明なクライアント、クライアント認証が含まれていない、認証コードが不正、認証コードが無効、リダイレクトURLが不正、別のクライアントに適用されている。'
        end
      end

      # リフレッシュトークンからアクセストークンを再取得
      # @param access_token [String] Access Token
      # @param refresh_token [String] Refresh Token
      # @param expires_at [Integer] アクセストークンの有効期限(UNIX TIME)
      # @return [Hash] アクセストークン
      def refresh_token(access_token, refresh_token, expires_at)
        if access_token.empty?
          raise 'アクセストークンが存在しません'
        end
        if expires_at.nil?
          raise 'アクセストークンの有効期限が指定されていません'
        end
        if refresh_token.empty?
          raise 'リフレッシュトークンが存在しません'
        end
        params = {
          refresh_token: refresh_token,
          expires_at: expires_at
        }
        @access_token = OAuth2::AccessToken.new(@client, access_token, params)
        begin
          @access_token.refresh! if @access_token.expired?
        rescue OAuth2::Error
          raise 'アクセストークンの取得に失敗しました。次の原因が考えられます。原因: 不明なクライアント、アクセストークンが不正、リフレッシュトークンが不正、有効期限が不正。'
        end
      end
    end
  end
end
