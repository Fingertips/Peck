# encoding: utf-8

require 'preamble'



describe "The" do
  before do
    @order = ['1']
  end

  it "has order" do
    @order.should == %w(1)
  end

  describe "test" do
    before do
      @order << '2'
    end

    it "has order" do
      @order.should == %w(1 2)
    end

    describe "framework" do
      before do
        @order << '3'
      end

      it "has order" do
        @order.should == %w(1 2 3)
      end

      it "has order" do
        @order.should == %w(1 2 3)
      end
    end

    it "has order" do
      @order.should == %w(1 2)
    end
  end
end

# We need to specs to run now, not at exit because we want to inspect
# the outcomes.

Peck.run

require 'assert'

assert(Peck.counter.ran == 5,
  "Expected five specifications to have been run")

assert(Peck.counter.passed == 5,
  "Expected five specifications to have passed")

assert(Peck.contexts[0].label == "The",
  "Expected the title to be ‘The’")

assert(Peck.contexts[1].label == "The test",
  "Expected the title to be ‘The test’")

assert(Peck.contexts[2].label == "The test framework",
  "Expected the title to be ‘The test framework’")
