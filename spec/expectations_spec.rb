# encoding: utf-8

require File.expand_path('../preamble', __FILE__)
require 'peck/expectations'

describe Peck::Should::Proxy do
  it "keeps its context and block" do
    block = proc {}
    context = Class.new.new

    proxy = Peck::Should::Proxy.new(context, &block)
    proxy.context.should == context
    proxy.block.should == block
    proxy.negated.should == false
  end
end

describe Peck::Should::Specification do
  it "negates" do
    block = proc {}
    context = Class.new.new
    spec = Peck::Should::Specification.new(context, &block)
    spec.negated.should == false
    spec.not.negated.should == true
  end
end

class FakePeckSpec
  attr_accessor :expectations
  attr_accessor :specifications
  def initialize
    @expectations = []
    @specifications = []
  end
end

describe Peck::Should do
  it "initializes with the subject and insert itself into all specifications" do
    before = Thread.current['peck-spec']
    begin
      Thread.current['peck-spec'] = FakePeckSpec.new
      subject = Class.new.new
      wrapper = Peck::Should.new(subject)
      Thread.current['peck-spec'].expectations.should.include wrapper
    ensure
      Thread.current['peck-spec'] = before
    end

    # We do this to appease the context
    Thread.current['peck-spec'].expectations << 1
  end
end

describe "A common", Peck::Should do
  before do
    @fake_peck_spec = FakePeckSpec.new
    Thread.current['peck-spec'] = @fake_peck_spec
    @subject = Class.new.new
    @should = Peck::Should.new(@subject)
    Thread.current['peck-spec'] = nil
  end

  it "negates" do
    @should.instance_variable_get('@negated').should == false
    @should.not.object_id.should == @should.object_id
    @should.instance_variable_get('@negated').should == true
  end
end