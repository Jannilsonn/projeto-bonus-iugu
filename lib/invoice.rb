require "json"

class Invoice
  attr_reader :company, :pay_type, :token, :return_date, :expiration_date, :value, :status

  def initialize(company:, pay_type:, token:, expiration_date:, return_date:'', value:, status:)
    @company = company
    @pay_type = pay_type
    @token = token
    @expiration_date = expiration_date
    @return_date = return_date
    @value = value
    @status = status
  end

  def self.unpaid
    file = File.read('spec/fixtures/unpaid_invoices.json')
    JSON.parse(file, symbolize_names: true).map { |item| new(**item) }
  end

  def self.create(invoices = unpaid)
    FileData.build(invoices).each do |data|
      file_data = ''
      file_data << "#{Validate.total_invoices(data)}"
      file_data << "#{data.body.join}"
      file_data << "#{Validate.total_invoice_amount(data)}"

      file = File.new("invoices/unpaid/#{Time.now.strftime("%Y%m%d")}_#{data.key}.TXT", 'w')
      file.write "#{file_data}"
      file.close
      file
    end
  end

  def self.update(invoices)
    FileData.build(invoices).each do |data|
      file_data = ''
      file_data << "#{Validate.total_invoices(data)}"
      file_data << "#{data.body.join}"
      file_data << "#{Validate.total_invoice_amount(data)}"

      file = File.new("invoices/paid/#{Time.now.strftime("%Y%m%d")}_#{data.key}.TXT.PRONTO", 'w')
      file.write "#{file_data}"
      file.close
      file
    end
  end

  def self.pay
    create
    invoices = []
    Dir.new("./invoices/unpaid").each_child.map  do |file_name|
      line = File.readlines("invoices/unpaid/#{file_name}")
      line.delete_at(0)
      line.pop()

      invoices << line.map do |item|
        new(
          company: file_name.split("_")[2].gsub('.TXT',''),
          pay_type: file_name.split("_")[1],
          token: item.split[1],
          expiration_date: item.split[2],
          return_date: "#{Time.now.strftime("%Y%m%d")}",
          value: item.split[4],
          status: '5'
        )
      end
      system("mv ./invoices/unpaid/#{file_name} ./invoices/in_process/")
    end

    update(invoices.flatten(2))
  end

  def self.done
    return false unless done?
    Dir.new("./invoices/in_process").each_child.map  do |file_name|
      system("rm ./invoices/in_process/#{file_name}")
    end
    true
  end

  def self.done?
    paid = Dir.new("./invoices/paid").each_child.map  { |file_name| file_name }.size
    in_process = Dir.new("./invoices/in_process").each_child.map  { |file_name| file_name }.size

    paid == in_process
  end
end