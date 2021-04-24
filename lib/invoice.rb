require "json"

class Invoice
  attr_reader :company, :pay_type, :token, :expiration_date, :value, :status

  def initialize(company:, pay_type:, token:, expiration_date:, value:, status:)
    @company = company
    @pay_type = pay_type
    @token = token
    @expiration_date = expiration_date
    @value = value
    @status = status
  end

  def self.all
    file = File.read('spec/fixtures/unpaid_invoices.json')
    JSON.parse(file, symbolize_names: true).map { |item| new(**item) }
  end

  def self.create(invoices = all)
    FileData.build(invoices).each do |data|
      file_data = ''
      file_data << "H #{Validate.total_invoices(data)}\n"
      file_data << "#{data.body.join}"
      file_data << "F #{Validate.total_invoice_amount(data)}"

      file = File.new("invoices/unpaid/#{Time.now.strftime("%Y%m%d")}_#{data.key}.TXT", 'w')
      file.write "#{file_data}"
      file.close
      file
    end
  end

  def self.pay
    # TODO: Pagar faturas
      # Pegar todos os arquivos do diretório invoices/unpaid
      # Editar o status para 05
      # E mover para o diretório invoices/paid com .PRONTO
  end
end