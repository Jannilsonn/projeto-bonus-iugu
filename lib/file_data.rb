require 'pry'

class FileData
  attr_reader :key, :body

  def initialize(key: '', body: [])
    @key = key
    @body = body
  end

  def self.build(invoices)
    return 'ERROR: Only (Array) is accepted as parameter' if invoices.class != Array
    return 'ERROR: (Array) cannot be empty!' if invoices.empty?

    all_errors = errors(invoices)
    
    return all_errors unless all_errors.empty?

    file_data = format(invoices)

    fusion(file_data)
  end

  private

  def self.errors(file_data)
    file_data.filter_map { |invoice| set_error(invoice) }.first
  end

  def self.set_error(invoice)
    all_errors = {}
    invoice.instance_variables.each do |attr|
      attr_format = "#{attr}".gsub('@','')
      if attr_format == 'type' || attr_format == 'pay_type'        
        validate = eval("Validate.file_name(pay_type: invoice.pay_type, type: invoice.type)")
        eval("all_errors[:file_name] = validate if validate.include? 'ERROR:'")
      else
        if attr_format != 'return_date'
          validate = eval("Validate.invoice_#{attr_format}(#{attr_format}: invoice.#{attr_format})")
          eval("all_errors[:#{attr_format}] = validate if validate.include? 'ERROR:'")
        end
      end
    end
    all_errors
  end

  def self.format(invoices)
    file_data = invoices.map do |invoice|
      new(
        key: "#{Validate.file_name(pay_type: invoice.pay_type, type: invoice.type)}",
        body: [
          "#{Validate.invoice_token(token: invoice.token)}"\
          "#{Validate.invoice_due_date(due_date: invoice.due_date)}"\
          "#{Validate.invoice_return_date(invoice.return_date)}"\
          "#{Validate.invoice_value(value: invoice.value)}"\
          "#{Validate.invoice_status(status: invoice.status)}"
        ]
      )
    end
  end

  def self.fusion(file_data)
    file_data.combination(2) do |obj|
      if obj[0].key == obj[1].key
        obj[0].body << obj[1].body.join
        file_data.delete(obj[1])
      end
    end
  end
end
