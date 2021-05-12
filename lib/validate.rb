class Validate
  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def self.file_name(pay_type: '', type: '')
    return "#{pay_type.gsub(/\s+/, "").upcase}_#{type.gsub(/\s+/, "").upcase}" unless pay_type.empty? || type.empty?
    'ERROR: Validate.file_name expected 2 parameters'
  end

  def self.total_invoices(total: nil)
    if total&.body
      "H #{format('%05d', total.body.size.to_i)}\n"
    else
      'ERROR: Validate.total_invoices empty (Array) impossible to calculate'
    end
  end

  def self.invoice_token(token: '')
    return "B #{token[0..19]}" if token && token.size == 20
    'ERROR: Validate.invoice_token expected (1) parameter with (20) chars'
  end

  def self.invoice_due_date(due_date: '')
    return " #{due_date.gsub(/\D/, "")}" if due_date && due_date.gsub(/\D/, "").size == 8
    'ERROR: Validate.invoice_due_date expected (1) parameter of type date'
  end

  def self.invoice_return_date(return_date)
    return " #{return_date.gsub(/\D/, "")}" unless return_date.empty?
    ' 00000000'
  end

  def self.invoice_value(value: '')
    return " #{format('%010d', value.gsub(/\D/, "").to_i)}" unless value.empty?
    'ERROR: Validate.invoice_value expected (1) parameter'
  end

  def self.invoice_status(status: '')
    return " #{format('%02d', status.gsub(/\D/, "").to_i)}\n" unless status.empty?
    'ERROR: Validate.invoice_status expected (1) parameter'
  end


  def self.total_invoice_amount(amount: nil)
    if amount&.body
      "F #{format('%015d', amount.body.map { |invoice| invoice.split(" ")[4].to_i }.sum)}"
    else
      'ERROR: Validate.total_invoice_amount empty (Array) impossible to calculate'
    end
  end
end