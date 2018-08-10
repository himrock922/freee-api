# frozen_string_literal: true

module Freee
  module Api
    class Token
      # oauth-xx client(read only)
      attr_reader :client
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
          site: Parameter::SITE,
          authorize_url: AUTHORIZE_URL,
          token_url: TOKEN_URL
        }

        raise 'アプリケーションIDが入力されていません' if app_id.empty?
        raise 'Secretが入力されていません' if secret.empty?
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
        raise '認証用コードを返すためのリダイレクトURLが指定されていません' if redirect_uri.empty?
        @client.auth_code.authorize_url(redirect_uri: redirect_uri)
      end

      # アクセストークン関係のパラメータを取得
      # @param code [String] Authentication Code
      # @param redirect_uri [String] redirect_url for Access Token
      # @return [Hash] アクセストークン
      def get_access_token(code, redirect_uri)
        raise '認証用コードが存在しません' if code.empty?
        raise 'アクセストークンを返すためのリダイレクトURLが指定されていません' if redirect_uri.empty?
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
        raise 'アクセストークンが存在しません' if access_token.empty?
        raise 'アクセストークンの有効期限が指定されていません' if expires_at.nil?
        raise 'リフレッシュトークンが存在しません' if refresh_token.empty?
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
