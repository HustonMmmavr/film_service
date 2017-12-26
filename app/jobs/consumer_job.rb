require_dependency "#{Rails.root.join('app', 'services', 'consumer.rb')}"
require 'sneakers'
class ConsumerJob < ApplicationJob
  # p Sneakers::Worker
  include Sneakers::Worker
  # ActiveJob::Base.queue_adapter = :sneakers
  # p 'b'
  # queue_as :job_queue
  # p 's'
  # This worker will connect to "dashboard.posts" queue
  # env is set to nil since by default the actuall queue name would be
  # "dashboard.posts_development"
  from_queue "fs.del", env: nil

  # def perform_latrt()
  # def perform()
    # p 'a'
  # end

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to RecentPosts service without
  # changes
  # def work(msg)
  #   begin
  #      p 'a'
  #      job_data = JSON.load(msg)
  #      Film.destroy(job_data[:id])
  #      ack!
  #    rescue => err
  #      p err
  #      reject!
  #    end
  # end
  # def perform()
  #
  #   p $redis.dbsize()
  #   p Consumer.list
  #   data = Consumer.pop
  #   p data
  #   while data != nil
  #     Film.destroy(param["id"])
  #     data = Consumer.pop
  #     # Do something later
  #   end
  # end

  def work(raw_post)
    # p 'a'
    p raw_post
    # data = JSON.load(raw_post)
    # Film.destroy(data[:id])
    Consumer.push(raw_post)
    ack! # we need to let queue know that message was received
  end
end
