require "semantic_logger"
require "journald/logger"
require "semantic_logger_journald/formatter"

module SemanticLoggerJournald
  class Appender < SemanticLogger::Subscriber
    attr_reader :logger

    def initialize(logger: nil, syslog_id: nil, **args, &block)
      @logger = logger || Journald::Logger.new(syslog_id)
      super(**args, &block)
    end

    def log(log)
      @logger.send_message(formatter.call(log, self))
    end

    private

    def default_formatter
      SemanticLoggerJournald::Formatter.new
    end
  end
end
