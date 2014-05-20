require 'rubygems'
require 'bundler'

Bundler.require
#require 'rack-stream'
require 'rainbows'
#
#

class Firehose
  def self.call(env)
    puts "starting"
    [200, {"Content-Type" => "text/plain"}, new]
  end

  def each
    File.open("big_ass.csv", "r") do |infile|
      while (line = infile.gets)
        yield line
      end
    end
    puts 'Done'
  end
end

use Raindrops::Middleware

#worker_processes 4
#Rainbows! do
  #use :FiberSpawn
  #worker_connections 100
#end

run Firehose
