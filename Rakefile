# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'sneakers/tasks'
# require './lib/tasks/sneakers/tasks.rb'
namespace :rabbitmq do
  desc "Setup routing"
  task :setup do
    require "bunny"

    conn = Bunny.new
    conn.start

    ch = conn.create_channel

    # get or create exchange
    p '----------------------------------'
    x = ch.fanout("aggregator.fs")
    p x
    # get or create queue (note the durable setting)
    queue = ch.queue("fs.del", durable: true)

    # bind queue to exchange
    queue.bind("aggregator.fs")

    conn.close
  end
end
Rails.application.load_tasks
