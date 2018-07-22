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
  end
end
