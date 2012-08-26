require 'preamble'

describe "The test framework" do
  it "discovers failure" do
    true.should == false
  end
end

# We need to specs to run now, not at exit because we want to inspect
# the outcomes.

Peck.run

require 'assert'

assert(Peck.counter.ran == 1,
  "Expected one specification to have been run")

assert(Peck.counter.passed == 0,
  "Expected no specifications to have passed")

assert(Peck.counter.failed == 1,
  "Expected one specifications to have failed")

assert(Peck.counter.pending.empty? == true,
  "Expected no specifications to be pending")

assert(Peck.counter.events.empty? == false,
  "Expected an error to have happened")
