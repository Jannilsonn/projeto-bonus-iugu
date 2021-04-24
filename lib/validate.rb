class Validate
  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def self.file_name(pay_type, company)
    "#{pay_type.gsub(/\s+/, "").upcase}_#{company.gsub(/\s+/, "").upcase}"
  end

  def self.invoice_token(token)
    token[0..19]
  end

  def self.invoice_due_date(expiration_date)
    expiration_date.gsub(/\D/, "")
  end

  def self.invoice_value(value)
    format('%010d', value.gsub(/\D/, "").to_i)
  end

  def self.invoice_status(status)
    format('%02d', status.gsub(/\D/, "").to_i)
  end

  def self.total_invoices(data)
    format('%05d', data.body.size.to_i)
  end

  def self.total_invoice_amount(data)
    format('%015d', data.body.map { |invoice| invoice.split(" ")[3].to_i }.sum)
  end
end