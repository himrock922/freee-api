# frozen_string_literal: true

RSpec.describe Freee::Api::Deals do
  subject do
    described_class.new
  end

  describe '#create_deal' do
    context '取引（収入／支出）の作成' do
      before do
        WebMock.stub_request(:post, 'https://api.freee.co.jp/api/1/deals').to_return(
          body: JSON.generate(
            deal: [
              {
                id: 101,
                company_id: 1,
                issue_date: '2013-01-01',
                due_date: '2013-02-28',
                amount: 5250,
                due_amount: 0,
                type: 'expense',
                partner_id: 201,
                ref_number: '123-456',
                details: [
                  {
                    account_item_id: 803,
                    tax_code: 6,
                    item_id: 501,
                    section_id: 1,
                    tag_ids: [1, 2, 3],
                    amount: 5250,
                    vat: 250,
                    description: '備考'
                  }
                ],
                paymenrs: [
                  {
                    date: '2013-01-28',
                    from_walletable_type: 'bank_account',
                    from_walletable_id: 103,
                    amount: 5250
                  }
                ]
              }
            ]
          ),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
      it '200' do
        params = {
          company_id: 1,
          issue_date: '2013-01-01',
          due_date: '2013-02-28',
          type: 'expense',
          partner_id: 201,
          ref_number: '123-456',
          details: [
            {
              account_item_id: 803,
              tax_code: 6,
              item_id: 501,
              section_id: 1,
              tag_ids: [1, 2, 3],
              amount: 5250,
              description: '備考'
            }
          ],
          paymenrs: [
            {
              date: '2013-01-28',
              from_walletable_type: 'bank_account',
              from_walletable_id: 103,
              amount: 5250
            }
          ]
        }
        response = subject.create_deal('access_token', params)
        expect(response.body['deal'][0]['id']).to eq 101
        expect(response.body['deal'][0]['company_id']).to eq 1
        expect(response.body['deal'][0]['issue_date']).to eq '2013-01-01'
      end
      it '必要なパラメータが不足' do
        params = { issue_date: '2013-01-01', type: 'expense', company_id: 1 }
        non_issue_params = { issue_date_dummy: 1 }
        non_type_params = { issue_date: '2013-01-01' }
        non_company_params = { issue_date: '2013-01-01', type: 'expense' }
        expect { subject.create_deal('', params) }.to raise_error(RuntimeError, 'アクセストークンが設定されていません')
        expect { subject.create_deal('access_token', non_issue_params) }.to raise_error(RuntimeError, '収入・支出の発生日が指定されていません')
        expect { subject.create_deal('access_token', non_type_params) }.to raise_error(RuntimeError, '収支区分が指定されていません')
        expect { subject.create_deal('access_token', non_company_params) }.to raise_error(RuntimeError, '事業所IDが設定されていません')
      end
    end
  end
end
