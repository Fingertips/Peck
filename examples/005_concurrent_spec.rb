# encoding: utf-8

require 'preamble'

Peck.concurrency = 80

if Peck.const_defined?(:Notifiers)
  Peck::Notifiers::Documentation.runtime_report_cutoff = 202
end

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
  "Expected 100 specifications to have been run")
