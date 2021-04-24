require 'spec_helper'

describe 'Buscar e criar arquivos em débito e pagos' do
  #TODO: Pegar todas as cobranças via API pedentes com data de vencimento ultrapassada
  it 'EX: Cunsultar a API e pegar faturas não pagas' do
    invoices = Invoice.all

    expect(invoices[0].value).to eq '0000007500'
    expect(invoices[1].value).to eq '0000001000'
  end

  #TODO: Gera arquivos com dados de cobrança TIMESTAMP_MEIO_PAGAMENTO_EMISSAO.TXT no diretório /debt
  it 'EX: Gerar arquivos não pagos' do
    Invoice.create

    expect(File.read("invoices/unpaid/#{Time.now.strftime("%Y%m%d")}_PIX_CODEPLAY.TXT")).to include(
      "B DU84G3F7HF8H49H 20200415 0000007500 01"
    )
  end

  #TODO: Lançar no sistema que a cobrança foi registrada em um arquivo com token da cobraça, nome do arquivo e data da emissão

  #TODO: Consultar arquivos de retorno que tem o resultado da cobrança
    # Ler o conteúdo do arquivo
    # Validar cada linha com a situação de retorno e atualizar a plataforma de pagmento via API
    # Mover arquivo para o diretório /done e renomea-lo com .PRONTO
end
