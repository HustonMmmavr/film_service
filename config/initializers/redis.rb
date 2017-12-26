$redis = Redis::Namespace.new("app:#{Rails.env}", redis: Redis.new)
