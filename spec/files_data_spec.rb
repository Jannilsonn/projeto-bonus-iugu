require 'spec_helper'

describe 'Formatar dados para criar arquivo' do
  it 'Criar uma formatação válida' do
    company = 'Code Play'
    pay_type = 'Boleto'
    token = 'HS4JSO69SNM48GDU639D'
    expiration_date =  '2020-04-20'
    value = '85.80'
    status = '1'

    invoices = [Invoice.new(
      company: company,
      pay_type: pay_type,
      token: token,
      expiration_date: expiration_date,
      value: value,
      status: status
    )]

    file_data = FileData.build(invoices)

    expect(file_data[0].key).to eq 'BOLETO_CODEPLAY'
    expect(file_data[0].body).to eq ["B HS4JSO69SNM48GDU639D"\
                                 " 20200420"\
                                 " 0000008580"\
                                 " 01\n"]
  end

  it 'Aceitar apenas array como parametro ao formatar' do
    company = 'Code Play'
    pay_type = 'Boleto'
    token = 'HS4JSO69SNM48GDU639D'
    expiration_date =  '2020-04-20'
    value = '85.80'
    status = '1'

    invoices = Invoice.new(
      company: company,
      pay_type: pay_type,
      token: token,
      expiration_date: expiration_date,
      value: value,
      status: status
    )

    file_data = FileData.build(invoices)

    expect(file_data).to eq 'Only array is accepted as parameter'
  end
end