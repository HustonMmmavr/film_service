require_dependency "#{Rails.root.join('app', 'services', 'consumer.rb')}"

class ClearingJob < ApplicationJob
  # queue_as :default
  p 'me'
  include Sidekiq::Worker

  def perform
  end
end
