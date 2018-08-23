# frozen_string_literal: true

RSpec.describe Freee::Api::AccountItems do
  subject do
    described_class.new
  end

  describe '#get_account_items' do
    context '勘定科目一覧の取得' do
      before do
        WebMock.stub_request(:get, 'https://api.freee.co.jp/api/1/account_items').to_return(
          body: JSON.generate(
            account_items: [
              {
                id: 101,
                name: 'ソフトウェア',
                shortcut: 'SOFUTO',
                shortcut_num: '123',
                default_tax_id: 12,
                default_tax_code: 108,
                categories: %w[資産 固定資産 無形固定資産]
              }
            ]
          ),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
      it '200' do
        params = { company_id: 1 }
        response = subject.get_account_items('access_token', params)
        expect(response.body['account_items'][0]['id']).to eq 101
        expect(response.body['account_items'][0]['name']).to eq 'ソフトウェア'
        expect(response.body['account_items'][0]['shortcut']).to eq 'SOFUTO'
        expect(response.body['account_items'][0]['shortcut_num']).to eq '123'
        expect(response.body['account_items'][0]['default_tax_id']).to eq 12
        expect(response.body['account_items'][0]['default_tax_code']).to eq 108
        expect(response.body['account_items'][0]['categories']).to include('資産', '固定資産', '無形固定資産')
      end
      it '必要なパラメータが不足' do
        params = { company_id_dummy: 1 }
        expect { subject.get_account_items('', params) }.to raise_error(RuntimeError, 'アクセストークンが設定されていません')
        expect { subject.get_account_items('access_token', params) }.to raise_error(RuntimeError, '事業所IDが設定されていません')
      end
    end
  end
end
