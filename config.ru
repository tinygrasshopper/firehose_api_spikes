require 'rubygems'
require 'bundler'
Bundler.require
#require 'rack-stream'
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

run Firehose
