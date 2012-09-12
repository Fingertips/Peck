require File.expand_path('../preamble', __FILE__)

describe "The context" do
  it "returns a readable inspect" do
    self.inspect.should =~ /#<Peck::Context:0x[\w\d]+ @description="The context">/
    self.class.inspect.should == '#<Peck::Context description="The context…">'
  end
end