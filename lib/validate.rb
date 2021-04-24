class Validate
  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def self.file_name(pay_type, company)
    "#{pay_type.gsub(/\s+/, "").upcase}_#{company.gsub(/\s+/, "").upcase}"
  end

  def self.total_invoices(data)
    return "H #{format('%05d', data.body.size.to_i)}\n" if data.body.any?
    'H 00000'
  end

  def self.invoice_token(token)
    return "B #{token[0..19]}" if token
    'B AAAAAAAAAAA00000000000'
  end

  def self.invoice_due_date(expiration_date)
    return " #{expiration_date.gsub(/\D/, "")}" if expiration_date
    ' 00000000'
  end

  def self.invoice_return_date(return_date)
    return " #{return_date.gsub(/\D/, "")}" unless return_date.empty?
    ' 00000000'
  end

  def self.invoice_value(value)
    return " #{format('%010d', value.gsub(/\D/, "").to_i)}" if value
    '00000000000'
  end

  def self.invoice_status(status)
    return " #{format('%02d', status.gsub(/\D/, "").to_i)}\n" if status
    ' 00'
  end


  def self.total_invoice_amount(data)
    return "F #{format('%015d', data.body.map { |invoice| invoice.split(" ")[4].to_i }.sum)}" if data.body.any?
    'F 000000000000000'
  end
end