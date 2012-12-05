require 'redis'
require 'uri'
uri = URI.parse("redis://redistogo:6efb18fa4497486ced8e17df30eb58c5@tench.redistogo.com:9239/")

REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :db => uri.user)