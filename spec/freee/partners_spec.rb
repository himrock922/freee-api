# frozen_string_literal: true

RSpec.describe Freee::Api::Partners do
  subject do
    described_class.new
  end

  describe '#get_partners' do
    context '取引先一覧の取得' do
      before do
        WebMock.stub_request(:get, 'https://api.freee.co.jp/api/1/partners').to_return(
          body: JSON.generate(
            partners: [
              {
                id: 101,
                company_id: 1,
                name: 'ABC商店',
                shortcut1: 'ABC',
                shortcut2: '501'
              }
            ]
          ),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
      it '200' do
        params = { company_id: 1 }
        response = subject.get_partners('access_token', params)
        expect(response.body['partners'][0]['id']).to eq 101
        expect(response.body['partners'][0]['company_id']).to eq 1
        expect(response.body['partners'][0]['name']).to eq 'ABC商店'
        expect(response.body['partners'][0]['shortcut1']).to eq 'ABC'
        expect(response.body['partners'][0]['shortcut2']).to eq '501'
      end
      it '必要なパラメータが不足' do
        params = { company_id_dummy: 1 }
        expect { subject.get_partners('', params) }.to raise_error(RuntimeError, 'アクセストークンが設定されていません')
        expect { subject.get_partners('access_token', params) }.to raise_error(RuntimeError, '事業所IDが設定されていません')
      end
    end
  end
  describe '#create_partner' do
    context '取引先の作成' do
      before do
        WebMock.stub_request(:post, 'https://api.freee.co.jp/api/1/partners').to_return(
          body: JSON.generate(
            partners: [
              {
                id: 102,
                company_id: 1,
                name: '新しい取引先',
                shortcut1: 'NEWPARTNER',
                shortcut2: '502',
                long_name: '新しい取引先正式名称',
                name_kana: 'アタラシイトリヒキサキメイショウ',
                default_title: '御中',
                phone: '03-0987-6543',
                contact_name: '営業担当',
                email: 'contact@freee.co.jp',
                address_attributes: {
                  zipcode: '012-0009',
                  prefecture_code: 4,
                  street_name1: '湯沢市',
                  street_name2: 'Aビル'
                },
                partner_doc_setting_attributes: {
                  sending_method: 'posting'
                },
                partner_bank_account_attributes: {
                  bank_name: 'みずほ銀行',
                  bank_name_kana: 'ミズホ',
                  bank_code: '001',
                  branch_name: '銀座支店',
                  branch_kana: 'ギンザ',
                  branch_code: '101',
                  account_type: 'ordinary',
                  account_number: '1010101',
                  long_account_name: 'freee太郎',
                  account_name: 'フリータロウ'
                }
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
          name: '新しい取引先',
          shortcut1: 'NEWPARTNER',
          shortcut2: '502',
          long_name: '新しい取引先正式名称',
          name_kana: 'アタラシイトリヒキサキメイショウ',
          default_title: '御中',
          phone: '03-0987-6543',
          contact_name: '営業担当',
          email: 'contact@freee.co.jp',
          address_attributes: {
            zipcode: '012-0009',
            prefecture_code: 4,
            street_name1: '湯沢市',
            street_name2: 'Aビル'
          },
          partner_doc_setting_attributes: {
            sending_method: 'posting'
          },
          partner_bank_account_attributes: {
            bank_name: 'みずほ銀行',
            bank_name_kana: 'ミズホ',
            bank_code: '001',
            branch_name: '銀座支店',
            branch_kana: 'ギンザ',
            branch_code: '101',
            account_type: 'ordinary',
            account_number: '1010101',
            long_account_name: 'freee太郎',
            account_name: 'フリータロウ'
          }
        }
        response = subject.create_partner('access_token', params)
        expect(response.body['partners'][0]['id']).to eq 102
        expect(response.body['partners'][0]['company_id']).to eq 1
        expect(response.body['partners'][0]['name']).to eq '新しい取引先'
        expect(response.body['partners'][0]['shortcut1']).to eq 'NEWPARTNER'
        expect(response.body['partners'][0]['shortcut2']).to eq '502'
      end
    end
  end
  describe '#update_partner' do
    context '取引先の更新' do
      before do
        WebMock.stub_request(:put, 'https://api.freee.co.jp/api/1/partners/102').to_return(
          body: JSON.generate(
            partners: [
              {
                id: 102,
                company_id: 1,
                name: '新しい取引先',
                shortcut1: 'NEWPARTNER',
                shortcut2: '502',
                long_name: '新しい取引先正式名称',
                name_kana: 'アタラシイトリヒキサキメイショウ',
                default_title: '御中',
                phone: '03-0987-6543',
                contact_name: '営業担当',
                email: 'contact@freee.co.jp',
                address_attributes: {
                  zipcode: '012-0009',
                  prefecture_code: 4,
                  street_name1: '湯沢市',
                  street_name2: 'Aビル'
                },
                partner_doc_setting_attributes: {
                  sending_method: 'posting'
                },
                partner_bank_account_attributes: {
                  bank_name: 'みずほ銀行',
                  bank_name_kana: 'ミズホ',
                  bank_code: '001',
                  branch_name: '銀座支店',
                  branch_kana: 'ギンザ',
                  branch_code: '101',
                  account_type: 'ordinary',
                  account_number: '1010101',
                  long_account_name: 'freee太郎',
                  account_name: 'フリータロウ'
                }
              }
            ]
          ),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
      it '200' do
        params = {
          id: 102,
          company_id: 1,
          name: '新しい取引先',
          shortcut1: 'NEWPARTNER',
          shortcut2: '502',
          long_name: '新しい取引先正式名称',
          name_kana: 'アタラシイトリヒキサキメイショウ',
          default_title: '御中',
          phone: '03-0987-6543',
          contact_name: '営業担当',
          email: 'contact@freee.co.jp',
          address_attributes: {
            zipcode: '012-0009',
            prefecture_code: 4,
            street_name1: '湯沢市',
            street_name2: 'Aビル'
          },
          partner_doc_setting_attributes: {
            sending_method: 'posting'
          },
          partner_bank_account_attributes: {
            bank_name: 'みずほ銀行',
            bank_name_kana: 'ミズホ',
            bank_code: '001',
            branch_name: '銀座支店',
            branch_kana: 'ギンザ',
            branch_code: '101',
            account_type: 'ordinary',
            account_number: '1010101',
            long_account_name: 'freee太郎',
            account_name: 'フリータロウ'
          }
        }
        response = subject.update_partner('access_token', params)
        expect(response.body['partners'][0]['id']).to eq 102
        expect(response.body['partners'][0]['company_id']).to eq 1
        expect(response.body['partners'][0]['name']).to eq '新しい取引先'
        expect(response.body['partners'][0]['shortcut1']).to eq 'NEWPARTNER'
        expect(response.body['partners'][0]['shortcut2']).to eq '502'
      end
      it '必要なパラメータが不足' do
        params = { id: 102, name: '新しい取引先', company_id: 1 }
        non_company_params = { id: 102, name: '新しい取引先' }
        non_id_params = { name: '新しい取引先', company_id: 1 }
        non_name_params = { id: 102, company_id: 1 }
        expect { subject.update_partner('', params) }.to raise_error(RuntimeError, 'アクセストークンが設定されていません')
        expect { subject.update_partner('access_token', non_company_params) }.to raise_error(RuntimeError, '事業所IDが設定されていません')
        expect { subject.update_partner('access_token', non_id_params) }.to raise_error(RuntimeError, '取引先IDが設定されていません')
        expect { subject.update_partner('access_token', non_name_params) }.to raise_error(RuntimeError, '取引先名が設定されていません')
      end
    end
  end
end
