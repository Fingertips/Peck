# encoding: utf-8

module Kernel
  private

  def assert(success, message=nil)
    unless success
      if defined?(@_failures)
        @_failures += 1
      else
        @_failures = 1
      end
      where = caller[0].split(":")[0,2].join(':')
      message ||= "Assertion failed"
      puts "\n  #{@_failures}) #{where}\n\t#{message}"
    end
  end

  def failures
    if defined?(@_failures)
      @_failures
    else
      0
    end
  end
end

at_exit do
  exit failures
end