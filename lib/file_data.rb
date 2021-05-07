class FileData
  attr_reader :key, :body

  def initialize(key: '', body: [])
    @key = key
    @body = body
  end

  def self.build(invoices)
    return 'ERROR: Only (Array) is accepted as parameter' if invoices.class != Array
    return 'ERROR: (Array) cannot be empty!' if invoices.empty?

    file_data = invoices.map do |invoice|
      new(
        key: "#{Validate.file_name(pay_type: invoice.pay_type, type: invoice.type)}",
        body: [
          "#{Validate.invoice_token(token: invoice.token)}"\
          "#{Validate.invoice_due_date(expiration_date: invoice.expiration_date)}"\
          "#{Validate.invoice_return_date(invoice.return_date)}"\
          "#{Validate.invoice_value(value: invoice.value)}"\
          "#{Validate.invoice_status(status: invoice.status)}"
        ]
      )
    end

    all_errors = errors(file_data)
    return all_errors unless all_errors.empty?

    file_data.combination(2) do |obj|
      if obj[0].key == obj[1].key
        obj[0].body << obj[1].body.join
        file_data.delete(obj[1])
      end
    end
  end

  def self.errors(file_data)
    all_errors = {}
    
    file_data.filter_map do |invoice|
      if invoice.body.join.include?('ERROR:')
        error_body = invoice.body.join.split('ERROR:')
        all_errors[:token] = error_body[1] unless error_body[1].empty?
        all_errors[:expiration_date] = error_body[2] unless error_body[2].empty?
        all_errors[:value] = error_body[3] unless error_body[3].empty?
        all_errors[:status] = error_body[4] unless error_body[4].empty?
      end

      if invoice.key.include?('ERROR:')
        error_key = invoice.key.split('ERROR:')
        all_errors[:total] = error_key[1] unless error_key[1].empty?
        all_errors[:amount] = error_key[2] unless error_key[2].empty?
      end
    end
    
    all_errors
  end
end
