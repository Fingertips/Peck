# encoding: utf-8

$:.unshift File.expand_path("../../lib", __FILE__)

require 'peck/flavors/documentation'

class FakeSpec
  attr_reader :label, :passed
  def initialize(label, passed=true)
    @label, @passed = label, passed
  end
  alias passed? passed
end

class Peck
  module Helpers
    private

    def capture_stdout
      stdout = $stdout
      $stdout = written = StringIO.new('')
      begin
        yield
      ensure
        $stdout = stdout
      end
      written.rewind
      written.read
    end
  end
end

Peck::Context.once do
  include Peck::Helpers
end