uri = URI.parse(ENV["REDIS_SERVER_URL"])

Redis.current = Redis.new(:uri => uri)