# encoding: utf-8

require 'preamble'

describe "The test framework" do
  it "fails" do
    fail
  end
end

# We need to specs to run now, not at exit because we want to inspect
# the outcomes.

Peck.run

require 'assert'

event = Peck.all_events[0]

assert(event.exception.class == RuntimeError,
  "Expected failure event to be a RuntimeError")