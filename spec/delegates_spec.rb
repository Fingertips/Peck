require 'peck/flavors/vanilla'

class Bird
  attr_reader :calls

  def initialize
    @calls = []
  end

  def started
    @calls << [:started]
  end

  def finished_spec(spec)
    @calls << [:finished_spec, spec]
  end
end

describe Peck::Delegates do
  it "forwards supported messages to delegates" do
    bird = Bird.new

    delegates = Peck::Delegates.new
    delegates << bird
    delegates.started

    call = bird.calls[-1]
    call[0].should == :started
  end
end