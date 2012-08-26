require 'preamble'

class State
  class << self
    attr_accessor :count
  end
  @count = 0
end

describe "The test framework" do
  before do
    State.count += 1
  end

  after do
    State.count -= 1
  end

  it "runs before before every spec" do
    State.count.should == 1
  end

  it "run after after every spec" do
    State.count.should == 1
  end
end

# We need to specs to run now, not at exit because we want to inspect
# the outcomes.

Peck.run

require 'assert'

assert(Peck.counter.ran == 2,
  "Expected two specifications to have been run")

assert(Peck.counter.passed == 2,
  "Expected two specifications to have passed")

assert(Peck.counter.failed == 0,
  "Expected no specifications to have failed")

assert(Peck.counter.pending.empty? == true,
  "Expected no specifications to be pending")

assert(Peck.counter.events.empty? == true,
  "Expected no errors to have happened")
