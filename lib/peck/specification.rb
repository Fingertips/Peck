class Peck
  class Specification
    attr_reader :description, :context
    attr_accessor :expectations, :errors

    def initialize(context, before, after, description, &block)
      @context      = context.new(self)
      @before       = before.dup
      @after        = after.dup
      @description  = description
      @block        = block

      @expectations = []
      @errors       = []

      @finished = false
    end

    def label
      "#{@context.class.label} #{@description}"
    end
  end
end