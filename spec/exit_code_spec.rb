require File.expand_path('../preamble', __FILE__)

describe Peck do
  it "returns an exit code with the number of failures" do
    failed_spec = %(

$:.unshift("#{File.expand_path('../../lib', __FILE__)}")
require "peck/flavors/quiet"

describe "Something" do
  it "fails" do
    1.should == 2
  end

  it "also fails" do
    2.should == 4
  end
end

    )
    system("ruby -e '#{failed_spec}'")
    $?.exitstatus.should == 2
  end
end