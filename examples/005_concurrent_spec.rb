# encoding: utf-8

require 'preamble'

Peck.concurrency = 100

describe "The test framework" do
  100.times do
    it "discovers the truth" do
      true.should == true
      sleep 0.2
    end
  end
end

Peck.run

require 'assert'

assert(Peck.counter.ran == 100,
  "Expected 100 specification to have been run")
