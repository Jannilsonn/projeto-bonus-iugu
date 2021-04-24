class FileData
  attr_reader :key, :body

  def initialize(key: '', body: [])
    @key = key
    @body = body
  end

  def self.build(invoices)
    return 'Only array is accepted as parameter' if invoices.class != Array

    file_data = invoices.map do |invoice|
      new(
        key: "#{Validate.file_name(invoice.pay_type, invoice.company)}",
        body: [
          "B #{Validate.invoice_token(invoice.token)}"\
          " #{Validate.invoice_due_date(invoice.expiration_date)}"\
          " #{Validate.invoice_value(invoice.value)}"\
          " #{Validate.invoice_status(invoice.status)}\n"
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
