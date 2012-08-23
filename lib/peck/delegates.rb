require 'set'

class Peck
  class Delegates < Set
    def self.instance
      @instance ||= new
    end

    MESSAGES = %w(
      started
      finished
      started_specification
      finished_specification
      received_missing
      received_exception
    ).freeze

    def supported_messages
      MESSAGES
    end

    def method_missing(method, *args, &block)
      method = method.to_s
      if supported_messages.include?(method)
        each do |delegate|
          if delegate.respond_to?(method)
            delegate.send(method, *args, &block)
          end
        end
      else
        super
      end
    end
  end

  class << self
    # This can be used by a `client' to receive status updates.
    #
    #   Peck.delegates << Notifier.new
    attr_reader :delegates
  end

  @delegates = Peck::Delegates.instance
end