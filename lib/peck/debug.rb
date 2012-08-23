class Peck
  def self.logger
    @logger ||= begin
      require 'logger'
      logger = Logger.new($stdout)
      logger.formatter = Logger::Formatter.new
      logger
    end
  end

  def self.log(message)
    logger.debug(message)
  end
end