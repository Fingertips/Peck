# encoding: utf-8

require 'preamble'

class Peck
  class Should
    class Specification
      def handle_the_truth
        context.it('handles the truth') do
          true.should == true
        end
      end
    end
  end
end

describe "The test framework" do
  should.handle_the_truth
end

Peck.run

require 'assert'

assert(Peck.counter.ran == 1,
  "Expected one specification to have been run")
