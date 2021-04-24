require 'spec_helper'

describe 'Gerenciar faturas' do
  context 'Cunsultas via API' do
    let(:invoices) { Invoice.unpaid }

    it 'EX: Cunsultar a API e pegar faturas não pagas' do
      expect(invoices[0].value).to eq '0000007500'
      expect(invoices[1].value).to eq '0000001000'
    end
  end

  context 'Gerar arquivos de faturas não pagas' do
    it 'EX: Gerar arquivos e verificar se está no diretório correto' do
      Invoice.create

      expect(File.read("invoices/unpaid/#{Time.now.strftime("%Y%m%d")}_PIX_CODEPLAY.TXT")).to include(
        "B DU84G3F7HF8H49H 20200415 00000000 0000007500 01"
      )
    end
  end

  context 'Gerar arquivos de faturas pagas' do
    it 'Mudar fatura para paga' do
      Invoice.pay

      file = File.read("invoices/paid/#{Time.now.strftime("%Y%m%d")}_PIX_CODEPLAY.TXT.PRONTO")

      expect(file).to include(
        "B DU84G3F7HF8H49H 20200415 #{Time.now.strftime("%Y%m%d")} 0000007500 05"
      )
    end

    it 'Processar pagamento de faturas' do
      Invoice.pay

      expect(Dir.new("./invoices/in_process").each_child.map  { |file| file }).not_to eq([])
    end

    it 'Pagar faturas' do
      Invoice.pay

      expect(Invoice.done).to eq true
      expect(Dir.new("./invoices/in_process").each_child.map  { |file| file }).to eq([])
      expect(Dir.new("./invoices/paid").each_child.map  { |file| file }).not_to eq([])
    end
  end
end
