# encoding: utf-8

require 'preamble'

describe "The test framework" do
  it "discovers the truth" do
    true.should == true
  end
end

# We need to specs to run now, not at exit because we want to inspect
# the outcomes.

Peck.run

require 'assert'

assert(
  Peck.contexts.length == 1,
  "Expected 1 context to be defined")

assert(Peck.contexts[0].specs.length == 1,
  "Expected 1 specification to be defined")

expected_label = "The test framework"
actual_label   = Peck.contexts[0].label
assert(actual_label == expected_label,
  "Expected context label to be `#{expected_label}` but was `#{actual_label}`")

expected_label = "The test framework discovers the truth"
actual_label   = Peck.contexts[0].specs[0].label
assert(actual_label == expected_label,
  "Expected specification label to be `#{expected_label}` but was `#{actual_label}`")

assert(Peck.counter.ran == 1,
  "Expected one specification to have been run")

assert(Peck.counter.passed == 1,
  "Expected one specification to have passed")

assert(Peck.counter.failed == 0,
  "Expected no specifications to have failed")

assert(Peck.counter.pending.empty? == true,
  "Expected no specifications to be pending")

assert(Peck.counter.events.empty? == true,
  "Expected no errors or exceptions to have happened")
