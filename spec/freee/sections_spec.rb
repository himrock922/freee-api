# frozen_string_literal: true

RSpec.describe Freee::Api::Sections do
  subject do
    described_class.new
  end

  describe '#get_sections' do
    context '部門一覧の取得' do
      before do
        WebMock.stub_request(:get, 'https://api.freee.co.jp/api/1/sections').to_return(
          body: JSON.generate(
            sections: [
              {
                id: 101,
                company_id: 1,
                name: '開発部門',
                long_name: '開発部門',
                shortcut1: 'DEVELOPER',
                shortcut2: '123',
                indent_count: 1,
                parent_id: 11
              }
            ]
          ),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
      it '200' do
        params = { company_id: 1 }
        response = subject.get_sections('access_token', params)
        expect(response.body['sections'][0]['id']).to eq 101
        expect(response.body['sections'][0]['company_id']).to eq 1
        expect(response.body['sections'][0]['name']).to eq '開発部門'
        expect(response.body['sections'][0]['long_name']).to eq '開発部門'
        expect(response.body['sections'][0]['shortcut1']).to eq 'DEVELOPER'
        expect(response.body['sections'][0]['shortcut2']).to eq '123'
        expect(response.body['sections'][0]['indent_count']).to eq 1
        expect(response.body['sections'][0]['parent_id']).to eq 11
      end
      it '必要なパラメータが不足' do
        params = { company_id_dummy: 1 }
        expect { subject.get_sections('', params) }.to raise_error(RuntimeError, 'アクセストークンが設定されていません')
        expect { subject.get_sections('access_token', params) }.to raise_error(RuntimeError, '事業所IDが設定されていません')
      end
    end
  end
end
