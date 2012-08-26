module Kernel
  private

  def assert(success, message=nil)
    unless success
      @_failures ||= 0
      @_failures += 1
      where = caller[0].split(":")[0,2].join(':')
      message ||= "Assertion failed"
      puts "\n  #{@_failures}) #{where}\n\t#{message}"
    end
  end

  def failures
    @_failures || 0
  end
end

at_exit do
  exit failures
end