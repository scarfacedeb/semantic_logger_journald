module SemanticLoggerJournald
  class Formatter < SemanticLogger::Formatters::Raw
    LEVEL_MAP = {
      trace: Journald::LOG_DEBUG,
      debug: Journald::LOG_DEBUG,
      info: Journald::LOG_INFO,
      warn: Journald::LOG_WARNING,
      error: Journald::LOG_ERR,
      fatal: Journald::LOG_CRIT
    }.freeze

    KEY_JOIN = "__"

    def initialize(flatten_payload: KEY_JOIN, time_format: nil, **args)
      @flatten_payload = flatten_payload
      super(time_format: time_format, **args)
    end

    def level
      hash[:priority] = LEVEL_MAP.fetch(log.level)
    end

    def time
      hash[:syslog_timestamp] = time_format ? format_time(log.time) : format_syslog_time(log.time)
    end

    def tags
      hash.merge!(log.tags.map { |t| [t, 1] }.to_h) if log.tags&.any?
    end

    def named_tags
      hash.merge!(log.named_tags) if log.named_tags&.any?
    end

    def payload
      return if log.payload&.empty?

      payload = log.payload
      payload = flatten_hash(payload, "payload") if flatten_payload
      hash.merge!(payload)
    end

    private

    def flatten_hash(hash, prefix)
      hash.each_with_object({}) do |(key, val), h|
        if val.is_a?(Hash)
          flatten_hash(val).map { |nested_key, nested_val|
            h[join_keys(prefix, key, nested_key)] = nested_val
          }
        else
          h[join_keys(prefix, key)] = val
        end
      end
    end

    def join_keys(*args)
      args.join(@flatten_payload)
    end

    # from syslog_protocol gem
    def format_syslog_time(time)
      # The timestamp format requires that a day with fewer than 2 digits have
      # what would normally be a preceding zero, be instead an extra space.
      day = time.strftime("%d")
      day = day.sub(/^0/, " ") if day =~ /^0\d/
      time.strftime("%b #{day} %H:%M:%S")
    end
  end
end
