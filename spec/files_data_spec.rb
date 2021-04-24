require 'spec_helper'

describe 'Formatar dados para criar arquivo' do
  let(:company) {'Code Play'}
  let(:pay_type) {'Boleto'}
  let(:token) {'HS4JSO69SNM48GDU639D'}
  let(:expiration_date) {'2020-04-20'}
  let(:value) {'85.80'}
  let(:status) {'1'}

  context 'Formatos válidos' do
    let(:invoices) {
      [Invoice.new(
        company: company,
        pay_type: pay_type,
        token: token,
        expiration_date: expiration_date,
        value: value,
        status: status
      )]
    }

    it 'Criar uma formatação válida' do
      file_data = FileData.build(invoices)

      expect(file_data[0].key).to eq 'BOLETO_CODEPLAY'
      expect(file_data[0].body).to eq ["B HS4JSO69SNM48GDU639D"\
                                  " 20200420"\
                                  " 00000000"\
                                  " 0000008580"\
                                  " 01\n"]
    end
  end

  context 'Formatos inválidos' do
    let(:invoices) {
      Invoice.new(
        company: company,
        pay_type: pay_type,
        token: token,
        expiration_date: expiration_date,
        value: value,
        status: status
      )
    }

    it 'Aceitar apenas array como parametro ao formatar' do
      file_data = FileData.build(invoices)

      expect(file_data).to eq 'Only (Array) is accepted as parameter'
    end
  end
end