require 'spec_helper'

describe 'Validações de faturas' do
  context 'Nome do documento' do
    it 'Validar parte do nome do arquivo de fatura' do
      pay_type = 'Boleto'
      type = 'EMISSAO'

      file_name = Validate.file_name(pay_type: pay_type, type: type)

      expect(file_name).to eq 'BOLETO_EMISSAO'
    end

    it 'Mensagem de erro para nome do arquivo' do
      file_name = Validate.file_name

      expect(file_name).to eq 'ERROR: Validate.file_name expected 2 parameters'
    end
  end

  context 'Total de faturas e valor do montante' do
    let(:invoices) {
      FileData.build([
        Invoice.new(type: 'EMISSAO', pay_type: 'Boleto',
                    token: 'HS4JSO69SNM48GDU639D', due_date: '2020-04-20',
                    value: '85.80', status: '1'),
        Invoice.new(type: 'EMISSAO', pay_type: 'Boleto',
                    token: 'L0JDKIE64N448HS75M0Y', due_date: '2020-04-20',
                    value: '150.20', status: '1')
      ])
    }

    it 'Quantidade de faturas' do
      total = invoices.map { |invoice| Validate.total_invoices(total: invoice) }.join

      expect(total).to eq "H 00002\n"
    end

    it 'Mensagem de erro para quantidade de faturas' do
      total_invoices = Validate.total_invoices
      
      expect(total_invoices).to eq 'ERROR: Validate.total_invoices empty (Array) impossible to calculate'
    end

    it 'Valor total das faturas' do
      total = invoices.map { |invoice| Validate.total_invoice_amount(amount: invoice) }.join

      expect(total).to eq "F 000000000023600"
    end

    it 'Mensagem de erro para valor total das faturas' do
      total_invoice_amount = Validate.total_invoice_amount

      expect(total_invoice_amount).to eq 'ERROR: Validate.total_invoice_amount empty (Array) impossible to calculate'
    end
  end

  context 'Token da fatura' do
    it 'Validar token da fatura' do
      token = Validate.invoice_token(token: 'HS4JSO69SNM48GDU639D')

      expect(token).to eq "B HS4JSO69SNM48GDU639D"
    end

    it 'Mensagem de erro para token da fatura' do
      invoice_token = Validate.invoice_token

      expect(invoice_token).to eq 'ERROR: Validate.invoice_token expected (1) parameter with (20) chars'
    end
  end

  context 'Data de vencimento' do
    it 'Validar data de vencimento' do
      due_date = Validate.invoice_due_date(due_date: '2020-04-20')

      expect(due_date).to eq ' 20200420'
    end

    it 'Mensagem de erro para data de vencimento' do
      due_date = Validate.invoice_due_date

      expect(due_date).to eq 'ERROR: Validate.invoice_due_date expected (1) parameter of type date'
    end
  end

  context 'Valor de uma fatura' do
    it 'Validar valor de uma fatura' do
      value = Validate.invoice_value(value: '150.20')

      expect(value).to eq ' 0000015020'
    end

    it 'Mensagem de erro para o valor de uma fatura' do
      value = Validate.invoice_value

      expect(value).to eq 'ERROR: Validate.invoice_value expected (1) parameter'
    end
  end

  context 'Status de uma fatura' do
    it 'Validar status de uma fatura' do
      status = Validate.invoice_status(status: '1')

      expect(status).to eq " 01\n"
    end

    it 'Mensagem de erro para status de uma fatura' do
      status = Validate.invoice_status

      expect(status).to eq 'ERROR: Validate.invoice_status expected (1) parameter'
    end
  end
end