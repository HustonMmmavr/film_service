require_dependency "#{Rails.root.join('app', 'services', 'consumer.rb')}"

class ClearingJob < ApplicationJob
  # queue_as :default
  p 'me'
  include Sidekiq::Worker

  def perform
    p 'perfect'
    p $redis.dbsize()
    data = Consumer.pop
    p data
    while data != nil
      Film.destroy(param["id"])
      # Do something later
    end
  end
end
