require 'peck'

describe "The test framework" do
  it "discovers the truth" do
    true.should == true
  end
end

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