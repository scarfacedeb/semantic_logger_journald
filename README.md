# SemanticLoggerJournald

Plugin for semantic_logger that adds appender to send logs into journald.

It uses [journald-logger](https://github.com/theforeman/journald-logger) under the hood.

## Installation

```ruby
gem "semantic_logger_journald", "~> 0.1"
```

## Usage

To add journald appender to semantic_logger:

```ruby
require "semantic_logger_journald"

journald_appender = SemanticLoggerJournald::Appender.new(syslog_id: "my_service")
SemanticLogger.add_appender(appender: journald_appender)

logger = SemanticLogger[MyClass]
logger.info "Signed In", user_id: 1
```

You can also directly pass a journald-logger instance:

```ruby
jlogger = Journald::Logger.new("my_service")
journald_appender = SemanticLoggerJournald::Appender.new(logger: jlogger)
SemanticLogger.add_appender(appender: journald_appender)
```

## Formatter

By default, `SemanticLoggerJournald::Formatter` flattens the payload keys to convert them into individual fields:

```ruby
logger.info "Paid", order: { id: 1, status: "new" }
```

It'll produce the following journald fields:

```
MESSAGE=Paid
ORDER__ID=1
ORDER__STATUS=new
```

If you'd rather keep the payload intact, pass a custom formatter:

```ruby
formatter = SemanticLoggerJournald::Formatter.new(flatten_payload: false)

journald_appender = SemanticLoggerJournald::Appender.new(
  syslog_id: "my_service", 
  formatter: formatter
)

SemanticLogger.add_appender(appender: journald_appender)

logger.info "Paid", order: { id: 1, status: "new" }
```

It'll produce the following journald fields:

```
MESSAGE=Paid
ORDER={ id: 1, status: "new" }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scarfacedeb/semantic_logger_journald.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
