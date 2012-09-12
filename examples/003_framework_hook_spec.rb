# encoding: utf-8

require 'preamble'

Peck::Context.once do |context|
  context.class_eval do
    def status
      200
    end
  end
end

describe "The test framework" do
  it "is extended" do
    status.should == 200
  end
end

# We need to specs to run now, not at exit because we want to inspect
# the outcomes.

Peck.run

require 'assert'

assert(Peck.counter.ran == 1,
  "Expected one specification to have been run")

assert(Peck.counter.passed == 1,
  "Expected one specification to have passed")

assert(Peck.counter.failed == 0,
  "Expected no specifications to have failed")

assert(Peck.counter.pending.empty? == true,
  "Expected no specifications to be pending")

assert(Peck.counter.events.empty? == true,
  "Expected no errors to have happened")
