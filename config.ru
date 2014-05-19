require 'rubygems'
require 'bundler'
require 'pry'
Bundler.require
#require 'rack-stream'
#
#

@@file_reading_process = Proc.new do
  File.open("big_ass.csv", "r") do |infile|
    while (line = infile.gets)
      Fiber.yield line
    end
  end
end

class Firehose
  include Rack::Stream::DSL
  stream do
    after_open do
      puts "started"

      request_fiber = Fiber.new &@@file_reading_process

      process_loop =  proc do
        if request_fiber.alive?
          chunk request_fiber.resume 
          EM.next_tick process_loop
        else
          close
        end
      end

       EM.next_tick process_loop
    end

    before_close do
      puts "ending"
    end

    [200, {'Content-Type' => 'text/plain'}, []]
  end
end

use Rack::Stream
run Firehose.new
