require 'redis'
require 'uri'
uri = URI.parse("redis://redistogo:PASSWORD@HOST.redistogo.com:9239/")

REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :db => uri.user)
