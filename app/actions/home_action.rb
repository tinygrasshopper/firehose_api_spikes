require 'benchmark'

class HomeAction < Cramp::Action
  def start
    puts "start of request"
    puts Benchmark.measure {
      File.open("/Users/jatin/Projects/Shop2Market/pocEMRuby/big_ass.csv", "r").each_line do |line|
        sleep 0.1
        render line
      end
      finish
    }
  end
end
