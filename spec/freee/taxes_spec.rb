# frozen_string_literal: true

RSpec.describe Freee::Api::Taxes do
  subject do
    described_class.new
  end

  describe '#get_tax_codes' do
    context '税区分コード一覧の取得' do
      before do
        WebMock.stub_request(:get, 'https://api.freee.co.jp/api/1/taxes/codes').to_return(
          body: JSON.generate(
            taxes: [
              {
                code: 21,
                name: 'sales_with_tax',
                name_ja: '課税売上'
              }
            ]
          ),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
      it '200' do
        params = { company_id: 1 }
        response = subject.get_tax_codes('access_token', params)
        expect(response.body['taxes'][0]['code']).to eq 21
        expect(response.body['taxes'][0]['name']).to eq 'sales_with_tax'
        expect(response.body['taxes'][0]['name_ja']).to eq '課税売上'
      end
      it '必要なパラメータが不足' do
        params = { company_id_dummy: 1 }
        expect { subject.get_tax_codes('', params) }.to raise_error(RuntimeError, 'アクセストークンが設定されていません')
        expect { subject.get_tax_codes('access_token', params) }.to raise_error(RuntimeError, '事業所IDが設定されていません')
      end
    end
  end
end
