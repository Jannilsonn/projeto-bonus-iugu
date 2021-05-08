require 'sidekiq'

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
    when 'super_hard'
      sleep 10
      puts '>>> Super hard'
    when 'hard'
      sleep 10
      puts '>>> Hard'
    else
      sleep 1
      puts '>>> Else'
    end
  end
end