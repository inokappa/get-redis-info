#!/usr/bin/env ruby 
require 'rubygems'
#require 'ncursesw'
#require 'parallel'
require 'yaml'                                                            
require 'terminal-table'
require 'redis'                                                           
require 'hiredis'


# connect to redis
class Con
  def initialize(host,port)
    @host = host
    @port = port
  end
  def get_redis_info(param)
    redis = Redis.new(:host => @host, :port => @port, driver: :hiredis)
    redis.info["#{param}"]
  end
end

class Redisinfo < Con
  def get_connectd_clients 
    ret = get_redis_info("connectd_clients")
    if ret == nil
      return '0'
    end
  end
  def get_port
    get_redis_info("tcp_port")
  end
  def get_used_memory
    get_redis_info("used_memory")
  end
  def get_total_connections_received 
    get_redis_info("total_connections_received")
  end
  def get_total_commands_processed  
    get_redis_info("total_commands_processed")
  end
  def get_mem_fragmentation_ratio  
    get_redis_info("mem_fragmentation_ratio")
  end
end
#
rows = []
filename = ARGV[0]
file = open(filename)
while text = file.gets do
  raw = text
  arr = raw.split(",")
  chk = Redisinfo.new("#{arr[0]}","#{arr[1]}")
  rows << [\
    "#{arr[0]}",\
    "#{chk.get_port}",\
    "#{chk.get_connectd_clients}",\
    "#{chk.get_used_memory}",\
    "#{chk.get_total_connections_received}",\
    "#{chk.get_total_commands_processed}",\
    "#{chk.get_mem_fragmentation_ratio}"]

  table = Terminal::Table.new :headings => [\
    'Host',\
    'Port',\
    'connectd_clients',\
    'used_memory',\
    'total_connections_received',\
    'total_commands_processed',
    'mem_fragmentation_ratio'], :rows => rows
end
#
puts table
