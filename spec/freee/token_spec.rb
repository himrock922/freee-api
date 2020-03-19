# frozen_string_literal: true

RSpec.describe Freee::Api::Token do
  subject do
    described_class.new('dummy_client_id', 'dummy_client_secret')
  end

  describe '#initialize' do
    it 'assigns id and secret' do
      expect(subject.client.id).to eq('dummy_client_id')
      expect(subject.client.secret).to eq('dummy_client_secret')
    end
    it 'assigns site from the options hash' do
      expect(subject.client.site).to eq('https://api.freee.co.jp')
    end
    it 'assigns authorize_uri from the options hash' do
      expect(subject.client.authorize_url).to eq('https://accounts.secure.freee.co.jp/oauth/authorize')
    end
    it 'assigns token_uri from the options hash' do
      expect(subject.client.token_url).to eq('https://accounts.secure.freee.co.jp/public_api/oauth/token')
    end
  end

  describe '#development_authorize' do
    it 'assigns development url' do
      expect(subject.development_authorize).to eq('https://accounts.secure.freee.co.jp/public_api/authorize?client_id=dummy_client_id&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code')
    end
  end

  describe '#authorize' do
    context '本番環境用の認証用コードを設定する' do
      it '成功' do
        expect(subject.authorize('localhost')).to eq('https://accounts.secure.freee.co.jp/oauth/authorize?client_id=dummy_client_id&redirect_uri=localhost&response_type=code')
      end
      it '失敗' do
        expect { subject.authorize('') }.to raise_error(RuntimeError, '認証用コードを返すためのリダイレクトURLが指定されていません')
      end
    end
  end

  describe '#get_access_token' do
    context 'アクセストークンを取得する' do
      before do
        WebMock.stub_request(:post, 'https://api.freee.co.jp/oauth/token').to_return(
          body: JSON.generate(
            access_token: 'access_token',
            token_type: 'bearer',
            expires_in: 86_400,
            refresh_token: 'refresh_token',
            scope: 'read write'
          ),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
      it '200' do
        response = subject.get_access_token('code', 'localhost')
        expect(response.token).to eq 'access_token'
        expect(response.params['token_type']).to eq 'bearer'
        expect(response.expires_in).to eq 86_400
        expect(response.params['scope']).to eq 'read write'
        expect(response.refresh_token).to eq 'refresh_token'
      end
      it '必要なパラメータが不足' do
        expect { subject.get_access_token('', 'localhost') }.to raise_error(RuntimeError, '認証用コードが存在しません')
        expect { subject.get_access_token('code', '') }.to raise_error(RuntimeError, 'アクセストークンを返すためのリダイレクトURLが指定されていません')
      end
    end
  end
end
