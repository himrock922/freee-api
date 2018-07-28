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
      expect(subject.client.site).to eq('https://secure.freee.co.jp/oauth/authorize')
    end
    it 'assigns token_uri from the options hash' do
      expect(subject.client.site).to eq('https://api.freee.co.jp/oauth/token')
    end
  end

  describe '#development_authorize' do
    it 'assigns development url∂' do
      expect(subject).to eq('https://secure.freee.co.jp/oauth/authorize?client_id=dummy_token7&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code')
    end
  end
end
