require 'spec_helper'

describe Api do
  context '.client' do
    subject { described_class.client }

    it 'É uma instância faraday' do
      expect(subject).to be_instance_of(Faraday::Connection)
    end

    it 'Usar configurações da url' do
      expect(subject.url_prefix).to eq URI('http://localhost:3000/api/v1')
    end

    it 'Content-Type está usando json' do
      expect(subject.headers['Content-Type']).to eq('application/json')
    end
  end
end