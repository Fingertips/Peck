# encoding: utf-8

$:.unshift File.expand_path("../../lib", __FILE__)

require 'peck/flavors/documentation'

class FakeSpec < Struct.new(:label)
end
