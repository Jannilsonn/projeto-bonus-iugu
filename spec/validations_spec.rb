require 'spec_helper'

describe 'Validações de faturas' do
  context 'Nome do documento' do
    it 'Validar parte do nome do arquivo de fatura' do
      pay_type = 'Boleto'
      type = 'EMISSAO'

      file_name = Validate.file_name(pay_type: pay_type, type: type)

      expect(file_name).to eq 'BOLETO_EMISSAO'
    end

    it 'Receber mensagem de erro para nome do arquivo' do
      file_name = Validate.file_name

      expect(file_name).to eq 'Validate.file_name expected 2 parameters'
    end
  end

  context 'Total de faturas e valor do montante' do
    it 'Quantidade de faturas' do
      invoices = FileData.build([
          Invoice.new(type: 'EMISSAO', pay_type: 'Boleto',
                      token: 'HS4JSO69SNM48GDU639D', expiration_date: '2020-04-20',
                      value: '85.80', status: '1'),
          Invoice.new(type: 'EMISSAO', pay_type: 'Boleto',
                      token: 'L0JDKIE64N448HS75M0Y', expiration_date: '2020-04-20',
                      value: '150.20', status: '1')
      ])

      total = invoices.map { |invoice| Validate.total_invoices(invoice) }.join

      expect(total).to eq "H 00002\n"
    end

    it 'Receber mensagem de erro para quantidade de faturas' do
      invoices = FileData.build([])

      expect(invoices).to eq "(Array) cannot be empty!"
    end
  end
end