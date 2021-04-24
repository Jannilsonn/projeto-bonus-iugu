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
    file_data = invoices.map do |invoice|
      FileData.new(
        key: "#{invoice.pay_type}_#{invoice.company}",
        data: [
          "B #{invoice.token}"\
          " #{invoice.expiration_date}"\
          " #{format('%010d', invoice.value.to_i)}"\
          " #{invoice.status}\n"
        ]
      )
    end

    file_data = file_data.combination(2) do |obj|
      if obj[0].key == obj[1].key
        obj[0].data << obj[1].data.join
        file_data.delete(obj[1])
      end
    end

    file_data.each do |data|
      new_data = ''
      new_data << "H #{format('%05d', data.data.size.to_i)}\n"
      new_data << "#{data.data.join}"
      new_data << "F #{format('%015d', data.data.map { |invoice| invoice.split(" ")[3].to_i }.sum)}"

      file = File.new("invoices/unpaid/#{Time.now.strftime("%Y%m%d")}_#{data.key}.TXT", 'w')
      file.write "#{new_data}"
      file.close
      file
    end

    true
  end

  def self.pay
    # TODO: Pagar faturas
      # Pegar todos os arquivos do diretório invoices/unpaid
      # Editar o status para 05
      # E mover para o diretório invoices/paid com .PRONTO
  end
end