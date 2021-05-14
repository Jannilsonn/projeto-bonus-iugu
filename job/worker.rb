require 'sidekiq'
require './lib/invoice'
require './lib/file_data'
require './lib/validate'
require './lib/api'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class OurWorker
  include Sidekiq::Worker

  def perform(complexity)
    case complexity
    when 'create'
      Invoice.create
    when 'pay'
      Invoice.pay
    else
      puts 'Call does not exist'
    end
  end
end