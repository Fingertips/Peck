# encoding: utf-8

class Peck
  class Error < RuntimeError
    attr_accessor :type

    def initialize(type, message)
      @type = type.to_s
      super message
    end

    def count_as?(type)
      @type == type.to_s
    end
  end
end