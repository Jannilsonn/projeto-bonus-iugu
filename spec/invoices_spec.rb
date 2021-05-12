require 'spec_helper'

describe 'Gerenciar faturas' do
  context 'Cunsultas via API' do
    let(:invoices) { Invoice.unpaid }

    it 'Cunsultar a API e pegar faturas não pagas' do
      expect(invoices[0].value).to eq '75.00'
      expect(invoices[1].value).to eq '10.00'
    end
  end

  context 'Gerar arquivos de faturas não pagas' do
    it 'Gerar arquivos e verificar se está no diretório correto' do
      Invoice.create

      expect(File.read("invoices/unpaid/#{Time.now.strftime("%Y%m%d")}_PIX_EMISSAO.TXT")).to include(
        "B 0841908bc678b307185b 20200415 00000000 0000007500 01"
      )
    end
  end

  context 'Gerar arquivos de faturas pagas' do
    let(:invoices) { Invoice.create }
    it 'Mudar fatura para paga' do
      Invoice.pay

      file = File.read("invoices/paid/#{Time.now.strftime("%Y%m%d")}_PIX_RETORNO.TXT.PRONTO")

      expect(file).to include(
        "B 0841908bc678b307185b 20200415 #{Time.now.strftime("%Y%m%d")} 0000007500 05"
      )
    end

    it 'Pagar faturas' do
      Invoice.pay

      expect(Dir.new("./invoices/paid").each_child.map  { |file| file }).not_to eq([])
      expect(Dir.new("./invoices/unpaid").each_child.map  { |file| file }).to eq([])
    end
  end

  context 'Mensagens de erros do key para nome do arquivo' do
    let(:error_pay_type) { 'ERROR: Validate.valid_pay_type pay type not found' }
    
    it 'Mensagem de erro para nome do arquivo com FileData.build' do
      invoice = FileData.build([
        Invoice.new(type: 'emissao', pay_type: '',
                    token: '15a48166c4d2121a7ac7', due_date: '2020-04-20',
                    value: '100.50', status: 'pending')
      ])

      expect(invoice[:file_name]).to eq error_pay_type
    end
  end

  context 'Mensagens de erros do body para token' do
    let(:error_token) { 'ERROR: Validate.invoice_token expected (1) parameter with (20) chars' }
    let(:invoice) {
      Invoice.new(type: 'EMISSAO', pay_type: '58960b194b31089fc7d2',
        token: '', due_date: '2020-04-20',
        value: '100.50', status: 'pending')
    }
    
    it 'Mensagem de erro para token com FileData.build' do
      error = FileData.build([invoice])

      expect(error[:token]).to eq error_token
    end

    it 'Mensagem de erro para token com Invoice.create' do
      error = Invoice.create([invoice])

      expect(error[:token]).to eq error_token
    end
  end

  context 'Mensagens de erros do body para data de vencimento' do
    let(:error_due_date) { 'ERROR: Validate.invoice_due_date expected (1) parameter of type date' }
    let(:invoice) {
      Invoice.new(type: 'EMISSAO', pay_type: '58960b194b31089fc7d2',
        token: '15a48166c4d2121a7ac7', due_date: '',
        value: '100.50', status: 'pending')
    }

    it 'Mensagem de erro para data de vencimento com FileData.build' do
      error = FileData.build([invoice])

      expect(error[:due_date]).to eq error_due_date
    end

    it 'Mensagem de erro para data de vencimento com Invoice.create' do
      error = Invoice.create([invoice])

      expect(error[:due_date]).to eq error_due_date
    end
  end

  context 'Mensagens de erros do body para valor da fatura' do
    let(:error_value) { 'ERROR: Validate.invoice_value expected (1) parameter' }
    let(:invoice) {
      Invoice.new(type: 'EMISSAO', pay_type: '58960b194b31089fc7d2',
        token: '15a48166c4d2121a7ac7', due_date: '2020-04-20',
        value: '', status: 'pending')
    }

    it 'Mensagem de erro para valor da fatura com FileData.build' do
      error = FileData.build([invoice])

      expect(error[:value]).to eq error_value
    end

    it 'Mensagem de erro para valor da fatura com Invoice.create' do
      error = Invoice.create([invoice])

      expect(error[:value]).to eq error_value
    end
  end

  context 'Mensagens de erros do body para status da fatura' do
    let(:error_status) { 'ERROR: Validate.valid_status pay type not found' }
    let(:invoice) {
      Invoice.new(type: 'EMISSAO', pay_type: '58960b194b31089fc7d2',
        token: '15a48166c4d2121a7ac7', due_date: '2020-04-20',
        value: '100.50', status: '')
    }

    it 'Mensagem de erro para status da fatura com FileData.build' do
      error = FileData.build([invoice])

      expect(error[:status]).to eq error_status
    end

    it 'Mensagem de erro para status da fatura com Invoice.create' do
      error = Invoice.create([invoice])

      expect(error[:status]).to eq error_status
    end
  end
end
