class FileData
  attr_reader :key, :body

  def initialize(key: '', body: [])
    @key = key
    @body = body
  end

  def self.build(invoices)
    return 'Only (Array) is accepted as parameter' if invoices.class != Array
    return '(Array) cannot be empty!' if invoices.empty?

    file_data = invoices.map do |invoice|
      new(
        key: "#{Validate.file_name(pay_type: invoice.pay_type, type: invoice.type)}",
        body: [
          "#{Validate.invoice_token(invoice.token)}"\
          "#{Validate.invoice_due_date(invoice.expiration_date)}"\
          "#{Validate.invoice_return_date(invoice.return_date)}"\
          "#{Validate.invoice_value(invoice.value)}"\
          "#{Validate.invoice_status(invoice.status)}"
        ]
      )
    end

    file_data.combination(2) do |obj|
      if obj[0].key == obj[1].key
        obj[0].body << obj[1].body.join
        file_data.delete(obj[1])
      end
    end
  end
end
