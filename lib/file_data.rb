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
    all_errors = {}
    
    file_data.filter_map do |invoice|
      file_name = Validate.file_name(pay_type: invoice.pay_type, type: invoice.type)
      all_errors[:file_name] = file_name if file_name.include? 'ERROR:'

      token = Validate.invoice_token(token: invoice.token)
      all_errors[:token] = token if token.include? 'ERROR:'

      due_date = Validate.invoice_due_date(due_date: invoice.due_date)
      all_errors[:due_date] = due_date if due_date.include? 'ERROR:'

      value = Validate.invoice_value(value: invoice.value)
      all_errors[:value] = value if value.include? 'ERROR:'

      status = Validate.invoice_status(status: invoice.status)
      all_errors[:status] = status if status.include? 'ERROR:'
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
