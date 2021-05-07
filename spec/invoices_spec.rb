require 'spec_helper'

describe 'Gerenciar faturas' do
  context 'Cunsultas via API' do
    let(:invoices) { Invoice.unpaid }

    it 'Cunsultar a API e pegar faturas não pagas' do
      expect(invoices[0].value).to eq '0000007500'
      expect(invoices[1].value).to eq '0000001000'
    end
  end

  context 'Gerar arquivos de faturas não pagas' do
    it 'Gerar arquivos e verificar se está no diretório correto' do
      Invoice.create

      expect(File.read("invoices/unpaid/#{Time.now.strftime("%Y%m%d")}_PIX_EMISSAO.TXT")).to include(
        "B DU84G3F7HF8H49H 20200415 00000000 0000007500 01"
      )
    end
  end

  context 'Gerar arquivos de faturas pagas' do
    it 'Mudar fatura para paga' do
      Invoice.pay

      file = File.read("invoices/paid/#{Time.now.strftime("%Y%m%d")}_PIX_RETORNO.TXT.PRONTO")

      expect(file).to include(
        "B DU84G3F7HF8H49H 20200415 #{Time.now.strftime("%Y%m%d")} 0000007500 05"
      )
    end

    it 'Pagar faturas' do
      Invoice.pay

      expect(Dir.new("./invoices/paid").each_child.map  { |file| file }).not_to eq([])
      expect(Dir.new("./invoices/unpaid").each_child.map  { |file| file }).to eq([])
    end
  end
end
