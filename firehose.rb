#!/usr/bin/env ruby
$:<< '../lib' << 'lib'

require 'goliath'

class Stream < Goliath::API
  def on_close(env)
    env.logger.info "Connection closed."
  end

  def response(env)
    env.logger.info "Starting new connection"
    shared_queue = Queue.new
    puts shared_queue.__id__
    shared_flag = false
    EM.defer lambda {
      File.open("big_ass.csv", "r") do |infile|
        while (line = infile.gets)
          shared_queue.push line
        end
      end

      shared_flag = true
    }

    streaming_loop = proc do
      while(shared_queue.empty?)
        env.stream_send(shared_queue.pop)
      end

      if shared_flag
        env.stream_close
      else
        EM.next_tick streaming_loop
      end
    end

    EM.next_tick streaming_loop
    streaming_response(202, {'X-Stream' => 'Goliath'})
  end
end
