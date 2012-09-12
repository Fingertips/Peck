# encoding: utf-8

require File.expand_path('../preamble', __FILE__)

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