class FileData
  attr_reader :key, :data

  def initialize(key: '', data: [])
    @key = key
    @data = data
  end
end