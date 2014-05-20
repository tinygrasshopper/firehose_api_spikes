require 'rubygems'
require 'bundler'
require 'pry'
Bundler.require
#require 'rack-stream'
#
#

@@file_reading_process = Proc.new do
  shared_queue = Queue.new
  shared_flag = false

  EM.defer do
    File.open("big_ass.csv", "r") do |infile|
      puts "READING"
      while (line = infile.gets)
        shared_queue.push line
      end
    end

    shared_flag = true
  end


  while !shared_flag
    Fiber.yield shared_queue.pop
  end

end

class Firehose
  include Rack::Stream::DSL
  stream do
    after_open do
      puts "started"

      request_fiber = Fiber.new &@@file_reading_process

      process_loop =  proc do
        if request_fiber.alive? && env["rack.stream"].state == :open
          chunk request_fiber.resume 
          EM.next_tick process_loop
        else
          close if env["rack.stream"].state == :open
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
